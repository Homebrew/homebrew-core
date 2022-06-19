class Jaq < Formula
  desc "Command-line deletion tool focused on safety, ergonomics, and performance"
  homepage "https://github.com/01mf02/jaq"
  url "https://static.crates.io/crates/jaq/jaq-0.6.0.crate"
  sha256 "aebeabacdd1571bd650e628c424a17ca92744a7b1f8b587059eb0a7ba7668987"
  license "MIT"
  head "https://github.com/01mf02/jaq.git", branch: "main"

  livecheck do
    url "https://crates.io/api/v1/crates/jaq/versions"
    regex(/"num":\s*"(\d+(?:\.\d+)+)"/i)
  end

  depends_on "rust" => :build

  def install
    system "tar", "--strip-components", "1", "-xzvf", "jaq-#{version}.crate"
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "1", shell_output("echo '{\"a\": 1, \"b\": 2}' | #{bin}/jaq '.a'")
    assert_match "2.5", shell_output("echo '1 2 3 4' | #{bin}/jaq -s 'add / length'")
  end
end
