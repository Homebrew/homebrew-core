class IgniteSwift < Formula
  desc "Static site builder for Swift developers"
  homepage "https://github.com/twostraws/Ignite"
  url "https://github.com/twostraws/Ignite/archive/refs/tags/0.7.1.tar.gz"
  sha256 "9d2b87d49a5c304530058a4866372048df556264851a39d84644efb3cf95e332"
  license "MIT"

  depends_on "python@3.14"

  # Needed at build time and at run time, since `ignite build` compiles the
  # user's site with Swift. macOS provides it through the Command Line Tools
  # or Xcode; on Linux, Homebrew installs its own `swift`.
  uses_from_macos "swift", since: :sonoma

  on_macos do
    depends_on macos: :sonoma
  end

  on_sequoia do
    # Workaround for https://github.com/apple/swift-argument-parser/issues/827
    # Conditional should really be Swift >= 6.2 but not available so using
    # a check on the specific ld version included with Xcode >= 26
    depends_on xcode: :build if DevelopmentTools.ld64_version >= "1221.4"
  end

  conflicts_with "ignite", because: "both install an ignite executable"

  deny_network_access!

  def fetch
    # Download Swift package dependencies while network access is allowed.
    # SwiftPM's own sandbox cannot nest inside Homebrew's build sandbox.
    system "swift", "package", "resolve", "--disable-sandbox"
  end

  def install
    # std_swift_args adds --disable-sandbox on macOS and --static-swift-stdlib on Linux,
    # so the Linux binary runs without a separate Swift runtime installed.
    system "swift", "build", "--product", "IgniteCLI", *std_swift_args
    bin.install ".build/release/IgniteCLI" => "ignite"
    # The CLI locates this helper beside its executable.
    (bin/"ignite-server.py").write "#!#{formula_opt_bin("python@3.14")}/python3.14\n" + File.read("server.py")
    chmod 0755, bin/"ignite-server.py"
  end

  test do
    assert_match "USAGE: ignite", shell_output("#{bin}/ignite --help")
    assert_match "Can't find Package.swift", shell_output("#{bin}/ignite build")
    assert_match "--directory", shell_output("#{bin}/ignite-server.py --help")
  end
end
