class Melody < Formula
  desc "Language that compiles to regular expressions"
  homepage "https://yoav-lavi.github.io/melody/book"
  url "https://github.com/yoav-lavi/melody/archive/refs/tags/v0.18.1.tar.gz"
  sha256 "c68c05c0d87d4ab1069196f339043252fb1754395d8e5504f5295a2fadcc51d2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "913cb7ea6a046bce06adf60206bfec85fa7cfc9cf74877d3924dc7119ff1bdfc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e94ac9cc31ef304151c7bcc451bdf156093a293cf72deb93be08a1a5be82b68a"
    sha256 cellar: :any_skip_relocation, monterey:       "b4b387df206e409693bd23198d0f0a2cbcfd8f19f8219126cf54d94dc3e1b19f"
    sha256 cellar: :any_skip_relocation, big_sur:        "026f2332073c8f8b0caab0b8bf45e92a7ae1e72ee94363a451e3f802aa505eb5"
    sha256 cellar: :any_skip_relocation, catalina:       "743690ceb65bfdf6ede286cc85d79292ae558620219d19cc8b87b3354d450cd1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ea1a449e0b31993e1263618d839917800b99282a01e4ab00909b230ed8d57db6"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/melody_cli")
  end

  test do
    mdy = "regex.mdy"
    File.write mdy, '"#"; some of <word>;'
    assert_match "#\\w+", shell_output("#{bin}/melody --no-color #{mdy}")
  end
end
