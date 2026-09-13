class Chisel < Formula
  desc "Collection of LLDB commands to assist debugging iOS apps"
  homepage "https://github.com/facebook/chisel"
  url "https://github.com/facebook/chisel/archive/refs/tags/2.0.1.tar.gz"
  sha256 "6f019d5e7ab5eb06542a9eccbbe29e7d26165d3676828a32e143575ff102d5f9"
  license "MIT"
  head "https://github.com/facebook/chisel.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "e08544b4aeb29c969ff159278ada6409af23b3ae9539d507e2926e08cbe1cf5e"
    sha256 cellar: :any, arm64_tahoe:       "077677ceec6cb1ffb4894e5db11e46e3668ea3ac438c63662e0de6aa5aeea590"
    sha256 cellar: :any, arm64_sequoia:     "d4afda45323f2c83fd95744680fd3c925b3a1fa4a6dd003e70daf27610b17e1d"
  end

  depends_on xcode: :build
  depends_on :macos

  conflicts_with "chisel-tunnel", because: "both install `chisel` binaries"

  def install
    libexec.install Dir["*.py", "commands"]

    # == LD_DYLIB_INSTALL_NAME Explanation ==
    # Brew will update binaries to ensure their internal paths are usable, but
    # modifying a code signed binary will invalidate the signature. To prevent
    # broken signing, this build specifies the target install name up front,
    # in which case brew doesn't perform its modifications.
    ld_dylib_install_name = opt_prefix/"lib/Chisel.framework/Chisel"

    # Xcode 27 rejects the project's iOS 10.1 deployment target, older Xcode clamps it silently
    xcodebuild "-arch", Hardware::CPU.arch,
               "-project", "Chisel/Chisel.xcodeproj",
               "-scheme", "Chisel",
               "-configuration", "Release",
               "-sdk", "iphonesimulator",
               *("IPHONEOS_DEPLOYMENT_TARGET=15.0" if MacOS::Xcode.version >= 27),
               "LD_DYLIB_INSTALL_NAME=#{ld_dylib_install_name}",
               "DSTROOT=#{prefix}",
               "INSTALL_PATH=/lib",
               "install"
  end

  def caveats
    <<~EOS
      Add the following line to ~/.lldbinit to load chisel when Xcode launches:
        command script import #{opt_libexec}/fbchisellldb.py
    EOS
  end

  test do
    ENV["PYTHONPATH"] = Utils.safe_popen_read("/usr/bin/lldb", "--python-path").chomp
    # This *must* be `/usr/bin/python3`. `fbchisellldb.py` does `import lldb`,
    # which will segfault if imported with a Python that does not match `/usr/bin/lldb`.
    system "/usr/bin/python3", libexec/"fbchisellldb.py"
  end
end
