class Peekaboo < Formula
  desc "macOS screen capture, accessibility inspection and UI automation"
  homepage "https://peekaboo.sh/"
  url "https://github.com/openclaw/Peekaboo.git",
      tag:      "v4.9.8",
      revision: "70dbc4183f390a5a72d5dc01d8a77eb672217070"
  license "MIT"
  head "https://github.com/openclaw/Peekaboo.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "17230b6c166608a6438860dcfe6647cf2ba553b3a4c3e2505dbf8dea88a8def4"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a7ecca78f9f21fb8b36334047a2c58b61cce125fdeeded7ec01fa7568bd67e23"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1a8bf5c2b06a8fde56aa7a042e2a590a81fd70f37e5de9db7130d1d70a209970"
  end

  depends_on xcode: ["26.0", :build]
  depends_on macos: :sequoia

  deny_network_access!

  def fetch
    # SwiftPM tries to apply its own sandbox, which cannot nest inside the
    # build sandbox; Homebrew's sandbox still confines the whole process.
    system "swift", "package", "--package-path", "Apps/CLI", "resolve", "--disable-sandbox"
  end

  def install
    cd "Apps/CLI" do
      system "swift", "build", "--product", "peekaboo", *std_swift_args
      libexec.install ".build/release/peekaboo"
    end

    # The binary links `@rpath/libswiftCompatibilitySpan.dylib`, which macOS 15
    # does not ship. Bundle it beside the binary as upstream does.
    system "xcrun", "swift-stdlib-tool", "--copy", "--scan-executable", libexec/"peekaboo",
           "--platform", "macosx", "--destination", libexec
    deuniversalize_machos libexec/"libswiftCompatibilitySpan.dylib"
    bin.install_symlink libexec/"peekaboo"

    generate_completions_from_executable(bin/"peekaboo", "completions")
  end

  test do
    ENV["PEEKABOO_CONFIG_DIR"] = testpath/".peekaboo"

    assert_match "Peekaboo #{version}", shell_output("#{bin}/peekaboo --version")

    system bin/"peekaboo", "config", "init"
    assert_path_exists testpath/".peekaboo/config.json"
    assert_match "Configuration is valid", shell_output("#{bin}/peekaboo config validate")
  end
end
