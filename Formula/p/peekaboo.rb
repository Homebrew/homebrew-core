class Peekaboo < Formula
  desc "macOS screen capture, accessibility inspection and UI automation"
  homepage "https://peekaboo.sh/"
  url "https://github.com/openclaw/Peekaboo.git",
      tag:      "v4.9.6",
      revision: "e08807d08c956471012b595a4d2bddb4dc8031ea"
  license "MIT"
  head "https://github.com/openclaw/Peekaboo.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "bcec3928b9f0983d9cd830c493bb8ff51896c0568a0faea4fc88568c770f1f6a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9cfc3a49a9e5486e8e8568a6c3b9b5038e06cf408896b0f93d08de8f27bdfce9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "54192a4762d72e117bacebfa93e8058864733e43a109c91408ca31143bb617f2"
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
