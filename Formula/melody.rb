class Melody < Formula
  desc "Language that compiles to regular expressions"
  homepage "https://yoav-lavi.github.io/melody/book"
  url "https://github.com/yoav-lavi/melody/archive/refs/tags/v0.13.5.tar.gz"
  sha256 "05fe3930f5e17de90ca15e515092055f1d3db5f2481ade0861a8bcef9e006c0f"
  license "MIT"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/melody_cli")
  end

  test do
    mdy = "regex.mdy"
    File.write mdy, '"#"; some of <word>;'
    assert_match "#(?:\\w)+", shell_output("melody --no-color #{mdy}")
  end
end
