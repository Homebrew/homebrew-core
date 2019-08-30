class Csound < Formula
  desc "Sound and music computing system"
  homepage "https://csound.com"
  url "https://github.com/csound/csound/archive/6.13.0.tar.gz"
  sha256 "183beeb3b720bfeab6cc8af12fbec0bf9fef2727684ac79289fd12d0dfee728b"

  bottle do
    sha256 "9bea923e26f957d157db576607b488c5770c5f762bd6b99060c1a7a0a5c3ae1b" => :mojave
    sha256 "a0d426d54f2858fd2907398a12bb19aa2cc6e507b1cf1235f53fc700b8663a60" => :high_sierra
    sha256 "a75a5810563ad5dfc9d02c8159c105963590317e01b41e271ff4e10a1bdeac9d" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "python" => [:build, :test]
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

    version = Language::Python.major_minor_version "python3"
    (lib/"python#{version}/site-packages/homebrew-csound.pth").write <<~EOS
      import site; site.addsitedir('#{libexec}')
    EOS
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

    system "python3", "-c", "import ctcsound"
  end
end
