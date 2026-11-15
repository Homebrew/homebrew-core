class Comrak < Formula
  desc "CommonMark + GFM compatible Markdown parser and renderer"
  homepage "https://comrak.ee"
  url "https://github.com/kivikakk/comrak/archive/refs/tags/v0.59.0.tar.gz"
  sha256 "74dfb6edda9b94b557685382162844ec9902cea3f10281585035c7a51d04fcfc"
  license "BSD-2-Clause"
  head "https://github.com/kivikakk/comrak.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "213d29ef3b214c03eebd10e524d4ac69e64bbd7be579f5f6b6583198d87b2575"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "8953834ddca48b8f3300579ad753985cb415c20ef0f8915b1e75d46e0e87f9ba"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "db1a3ab9c26defdf32859bb6505d6e2b813690b9fad8b0be3f868cc030722d40"
    sha256 cellar: :any,                 arm64_linux:       "6c580883b875f141c0229d4374bb1075a02279e13ffd96fc3e7baaa245d6f08b"
    sha256 cellar: :any,                 x86_64_linux:      "7545781123ce0c9b34178009a1e3c462e94b96d1b19f12a7f9a2da6e72fd395d"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/comrak --version")

    (testpath/"test.md").write <<~MARKDOWN
      # Hello, World!

      This is a test of the **comrak** Markdown parser.
    MARKDOWN

    output = shell_output("#{bin}/comrak test.md")
    assert_match "<h1>Hello, World!</h1>", output
    assert_match "<p>This is a test of the <strong>comrak</strong> Markdown parser.</p>", output
  end
end
