class Chisel < Formula
  desc "Collection of LLDB commands to assist debugging iOS apps"
  homepage "https://github.com/facebook/chisel"
  url "https://github.com/facebook/chisel/archive/refs/tags/2.0.1.tar.gz"
  sha256 "6f019d5e7ab5eb06542a9eccbbe29e7d26165d3676828a32e143575ff102d5f9"
  license "MIT"
  head "https://github.com/facebook/chisel.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_ventura:  "7ee4917934831d56a5925fb22554c0dd136f8553df9c92067e4564e527371e82"
    sha256 cellar: :any, arm64_monterey: "1aa32fddf646ce4a2772d5e10b39fddbe54a6383299346321d5d0dd067388471"
    sha256 cellar: :any, arm64_big_sur:  "bd381685bf1bf3682e51c355acbca980b35659b8161f226329b3a0196aab55df"
    sha256 cellar: :any, ventura:        "a07aface409179d4adea4e96654390ac19f6cc2422d0fa1e87d6331f68aa7782"
    sha256 cellar: :any, monterey:       "712007f0f4abd29073239839bd606dba927353444cf6baf4b058aedc92c17f0c"
    sha256 cellar: :any, big_sur:        "bec2fe6d1e6afec5b3b1c79f5f11b9f2219ff8e22d81e1b343cf525b91ea220e"
    sha256 cellar: :any, catalina:       "7ef6b79ffa9641e0617b2aec1b4f3dfcea59fc4059887c0d734baa1bda20441d"
    sha256 cellar: :any, mojave:         "70b49b0ba45571db3341adf586e1498a041492745cfa2130b2ef95b81d14fb85"
    sha256 cellar: :any, high_sierra:    "41797386262e226cf471995eac8ec50dffbf622140634254c6a7dab8a9471b48"
  end

  depends_on :macos

  conflicts_with "chisel-tunnel", because: "both install `chisel` binaries"

  def install
    libexec.install Dir["*.py", "commands"]

    # Fix: clang: error: the clang compiler does not support '-march=nehalem'
    inreplace "Chisel/Makefile", "xcodebuild", "xcodebuild -arch #{Hardware::CPU.arch}"
    # Fix: error: The Legacy Build System will be removed in a future release
    inreplace "Chisel/Chisel.xcodeproj/project.xcworkspace/xcshareddata/WorkspaceSettings.xcsettings",
              "<string>Original</string>",
              "<string>Original</string><key>DisableBuildSystemDeprecationDiagnostic</key><true/>"

    # == LD_DYLIB_INSTALL_NAME Explanation ==
    # This make invocation calls xcodebuild, which in turn performs ad hoc code
    # signing. Note that ad hoc code signing does not need signing identities.
    # Brew will update binaries to ensure their internal paths are usable, but
    # modifying a code signed binary will invalidate the signature. To prevent
    # broken signing, this build specifies the target install name up front,
    # in which case brew doesn't perform its modifications.
    system "make", "-C", "Chisel", "install", "PREFIX=#{lib}",
      "LD_DYLIB_INSTALL_NAME=#{opt_prefix}/lib/Chisel.framework/Chisel"
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
