class Csound < Formula
  desc "Sound and music computing system"
  homepage "https://csound.com"
  url "https://github.com/csound/csound/archive/6.13.tar.gz"
  sha256 "6118ffc1ee04eaeffe7483afc3d48190d93d0e97b51e25f0f3d71e44293827d6"

  bottle do
    sha256 "0b391ad5c63f24dff9f82b95545c2868f917ae1beadfea5dc4a1e4011b98f610" => :mojave
    sha256 "9f63f9c43fb7a3c48c7ea94b67a45149de337b6da6d8561b1cca039ca0320d08" => :high_sierra
    sha256 "3f003ad77d5abbc304cb60f16cf6d1fed60058f540d83f16be146e12d791f332" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "python" => [:build, :test]
  depends_on "python@2" => [:build, :test]
  depends_on "fltk"
  depends_on "liblo"
  depends_on "libsamplerate"
  depends_on "libsndfile"
  depends_on "numpy"
  depends_on "portaudio"
  depends_on "portmidi"
  depends_on "stk"

  conflicts_with "libextractor", :because => "both install `extract` binaries"
  conflicts_with "pkcrack", :because => "both install `extract` binaries"

  def install
    inreplace "CMakeLists.txt",
      %r{^set\(CS_FRAMEWORK_DEST\s+"~\/Library\/Frameworks" CACHE PATH "Csound framework path"\)$},
      "set(CS_FRAMEWORK_DEST \"#{frameworks}\")"

    args = std_cmake_args + %W[
      -DBUILD_FLUID_OPCODES=OFF
      -DBUILD_JAVA_INTERFACE=OFF
      -DBUILD_LUA_INTERFACE=OFF
      -DBUILD_PYTHON_INTERFACE=OFF
      -DCMAKE_INSTALL_RPATH=#{frameworks}
    ]

    mkdir "build" do
      system "cmake", "..", *args
      system "make", "install"
    end

    include.install_symlink "#{frameworks}/CsoundLib64.framework/Headers" => "csound"

    libexec.install "#{buildpath}/interfaces/ctcsound.py"

    ["python2", "python3"].each do |python|
      version = Language::Python.major_minor_version python
      (lib/"python#{version}/site-packages/homebrew-csound.pth").write <<~EOS
        import site; site.addsitedir('#{libexec}')
      EOS
    end
  end

  def caveats; <<~EOS
    To use the Python bindings, you may need to add to your .bash_profile:
      export DYLD_FRAMEWORK_PATH="$DYLD_FRAMEWORK_PATH:#{opt_prefix}/Frameworks"
  EOS
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

    ENV["DYLD_FRAMEWORK_PATH"] = "#{opt_prefix}/Frameworks"

    system "python2", "-c", "import ctcsound"
    system "python3", "-c", "import ctcsound"
  end
end
