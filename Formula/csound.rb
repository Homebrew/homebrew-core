class Csound < Formula
  desc "Sound and music computing system"
  homepage "https://csound.com"
  url "https://github.com/csound/csound/archive/6.13.0.tar.gz"
  sha256 "183beeb3b720bfeab6cc8af12fbec0bf9fef2727684ac79289fd12d0dfee728b"
  revision 2

  bottle do
    sha256 "cf136af722d787200955b6e5f11843532f2a1fcbbbe9d056a85b3d1f7e398d9f" => :mojave
    sha256 "446b57c6fb04a9542ece0ecc1c18b4c2b0e2347883e8ef45585d04a899ebe150" => :high_sierra
    sha256 "1f7c709c564459d9ef691754cd225b0732ccd18d19857b61733623fdc47609f7" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "eigen" => :build
  depends_on "python" => [:build, :test]
  depends_on "fltk"
  depends_on "fluid-synth"
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
    args = std_cmake_args + %W[
      -DBUILD_JAVA_INTERFACE=OFF
      -DBUILD_LUA_INTERFACE=OFF
      -DBUILD_PYTHON_INTERFACE=OFF
      -DCMAKE_INSTALL_RPATH=#{frameworks}
      -DCS_FRAMEWORK_DEST:PATH=#{frameworks}
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
      gi_fluidEngineNumber fluidEngine
      pyinit
      instr 1
          a_, a_, a_ chuap 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
          pyruni "from __future__ import print_function; print('hello, world')"
          a_signal STKPlucked 440, 1
          out a_signal
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
