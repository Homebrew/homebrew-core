class Comrak < Formula
  desc "CommonMark + GFM compatible Markdown parser and renderer"
  homepage "https://comrak.ee"
  url "https://github.com/kivikakk/comrak/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "b044929629fcad3ca2dfafeaccb3dfb8ea91deeae4ec10475eb7c322d1a721aa"
  license "BSD-2-Clause"
  head "https://github.com/kivikakk/comrak.git", branch: "main"

  bottle do
    manifest_sha256 "f273dd5ba74b8130ccefa7c12f13e56758695499a5e8fa8734af3ebc31ef6e6a"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "8f7eff57b3b615fbef26e07fc941aefef7653c6c2d5a6d61102b9f64201183ab"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "56180050bff64310f3ba72e8e441886d5b49dd1d94180219022a200ea913673b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "89e3af3ddd5e3134849ebc44a688e72d2ae88603592136e640f686b82788b6ad"
    sha256 cellar: :any,                 arm64_linux:       "43c6defdbac95b13fc07f7d85b3a6a24c41065f94ba85abc6328554df049c011"
    sha256 cellar: :any,                 x86_64_linux:      "16a1e8a8df4e62217361f52780f9f1052c19f96cedd7c76ac30949a3702076fa"
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
