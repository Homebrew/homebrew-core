class Mq < Formula
  desc "Jq-like command-line tool for markdown processing"
  homepage "https://mqlang.org/"
  url "https://github.com/harehare/mq/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "b74029b09be3e00710fc637fc52812ea604817755e4a658dc613f2b4e25f91a0"
  license "MIT"
  head "https://github.com/harehare/mq.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a1c18fa4e15eb74cfab122fc1221862fbf8140eb312e14c899d04305cd7f5fee"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "798f06428c0a2c48d939b883bbddb159dbe7485c314beada9802c47773db8d86"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b34b0977b7d021f31ad772509d46a920c7a2f876892c83eb44e5b528cdfe0d1f"
    sha256 cellar: :any_skip_relocation, sonoma:        "4d004baf6ce72280b1515b49029b0238a0986768e44e0e3b46393ccde748bd94"
    sha256 cellar: :any,                 arm64_linux:   "1308e7740d94eafcb108f27001454632c6ed63128cef60adafa3cf5a53c6c1e5"
    sha256 cellar: :any,                 x86_64_linux:  "32d4341daf7960d22f851c023e90859ed392c8db417c280cfa6409df908a61ce"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/mq-run")
    system "cargo", "install", *std_cargo_args(path: "crates/mq-lsp")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mq --version")

    (testpath/"test.md").write("# Hello World\n\nThis is a test.")
    output = shell_output("#{bin}/mq '.h' #{testpath}/test.md")
    assert_equal "# Hello World\n", output
  end
end
