class Peekaboo < Formula
  desc "macOS screen capture, accessibility inspection and UI automation"
  homepage "https://peekaboo.sh/"
  url "https://github.com/openclaw/Peekaboo.git",
      tag:      "v4.9.8",
      revision: "70dbc4183f390a5a72d5dc01d8a77eb672217070"
  license "MIT"
  head "https://github.com/openclaw/Peekaboo.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f499645122cc347594c0c5087de137b67ec1be33fb3cd9a81ed279f53d7120f9"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "0cc3af16a92cb12c37df45c74328a49a2c9c679e3b2d8560336b2023e03df081"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "8dd9757d85ff0d488d4ee23a9e41200ead2c5832a9ac8578562e2ce90db9143c"
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
