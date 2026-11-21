class Peekaboo < Formula
  desc "macOS screen capture, accessibility inspection and UI automation"
  homepage "https://peekaboo.sh/"
  url "https://github.com/openclaw/Peekaboo.git",
      tag:      "v4.9.10",
      revision: "fa2f76ed24ea8bc76e0f000124c909e96db3e29d"
  license "MIT"
  head "https://github.com/openclaw/Peekaboo.git", branch: "main"

  bottle do
    manifest_sha256 "39cc51cead82a3a9b6304a86ea7dafd82d8ed6b38353c013d1174d236a4f83dc"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d103b7361ee02b156ee60b872117c2ad8cb5c4cf3092c56b2a5edd9469556f20"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "79a4e7932f481f63fbe1438fa3db38d1e52b7399e0d2cd958547938a5fd1b28d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "958e47b0d6ead9e88ec6448831336324bd3d07d304bdfd6ccae490f6a164f808"
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
