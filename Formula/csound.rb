class Csound < Formula
  desc "Sound and music computing system"
  homepage "https://csound.com"
  url "https://github.com/csound/csound/archive/6.12.2.tar.gz"
  sha256 "39f4872b896eb1cbbf596fcacc0f2122fd3e5ebbb5cec14a81b4207d6b8630ff"
  revision 2

  bottle do
    sha256 "90be0b3b8bd7e174b9e08eac56a9e76780e95be8f1a0025fb82e75eff67e741b" => :mojave
    sha256 "f97c2e61a573ddeb770f0718ffe28167deba0358c58f2c96c5d45351f0d4a6e7" => :high_sierra
    sha256 "c7ffe61743dadae44f72e1d1707637d17da2721e6134b443964e3a76091e62a7" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "numpy" => [:build, :test]
  depends_on "python" => [:build, :test]
  depends_on "python@2" => [:build, :test]
  depends_on "swig" => :build
  depends_on "fltk"
  depends_on "liblo"
  depends_on "libsamplerate"
  depends_on "libsndfile"
  depends_on "portaudio"
  depends_on "portmidi"
  depends_on "stk"

  def install
    inreplace "CMakeLists.txt",
      %r{^set\(CS_FRAMEWORK_DEST\s+"~/Library/Frameworks"\)$},
      "set(CS_FRAMEWORK_DEST \"#{frameworks}\")"

    args = std_cmake_args + %W[
      -DBUILD_FLUID_OPCODES=OFF
      -DBUILD_JAVA_INTERFACE=OFF
      -DBUILD_LUA_INTERFACE=OFF
      -DCMAKE_INSTALL_RPATH=#{frameworks}
    ]

    mkdir "build" do
      system "cmake", "..", *args
      system "make", "install"

      macho = MachO.open("_csnd6.so")
      macho.change_install_name("@rpath/CsoundLib64.framework/Versions/6.0/CsoundLib64", "#{frameworks}/CsoundLib64.framework/CsoundLib64")
      macho.change_install_name("@rpath/libcsnd6.6.0.dylib", "#{lib}/libcsnd6.dylib")
      macho.delete_rpath(pwd.sub(%r{^/private/}, "/"))
      macho.write!
      libexec.install "_csnd6.so", "csnd6.py"
    end

    include.install_symlink frameworks/"CsoundLib64.framework/Headers" => "csound"

    libexec.install buildpath/"interfaces/ctcsound.py"

    ["python2", "python3"].each do |python|
      version = Language::Python.major_minor_version python
      (lib/"python#{version}/site-packages/homebrew-csound.pth").write <<~EOS
        import site; site.addsitedir('#{libexec}')
      EOS
    end
  end

  test do
    (testpath/"test.orc").write <<~EOS
      0dbfs = 1
      FLrun
      pyinit
      instr 1
          pyruni "from __future__ import print_function; print('hello, world')"
          aSignal STKPlucked 440, 1
          out aSignal
      endin
    EOS

    (testpath/"test.sco").write <<~EOS
      i 1 0 1
      e
    EOS

    ENV["OPCODE6DIR64"] = "#{HOMEBREW_PREFIX}/Frameworks/CsoundLib64.framework/Resources/Opcodes64"
    ENV["RAWWAVE_PATH"] = "#{HOMEBREW_PREFIX}/share/stk/rawwaves"

    require "open3"
    stdout, stderr, status = Open3.capture3("#{bin}/csound test.orc test.sco")

    assert_equal true, status.success?
    assert_equal "hello, world\n", stdout
    assert_match /^rtaudio:/, stderr
    assert_match /^rtmidi:/, stderr

    system "python2", "-c", "import csnd6"
    system "python2", "-c", "import ctcsound"
    system "python3", "-c", "import ctcsound"
  end
end
