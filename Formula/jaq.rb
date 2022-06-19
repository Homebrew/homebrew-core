class Jaq < Formula
  desc "JQ clone focussed on correctness, speed, and simplicity"
  homepage "https://github.com/01mf02/jaq"
  url "https://static.crates.io/crates/jaq/jaq-0.6.0.crate"
  sha256 "aebeabacdd1571bd650e628c424a17ca92744a7b1f8b587059eb0a7ba7668987"
  license "MIT"
  head "https://github.com/01mf02/jaq.git", branch: "main"

  livecheck do
    url "https://crates.io/api/v1/crates/jaq/versions"
    regex(/"num":\s*"(\d+(?:\.\d+)+)"/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dbede05c6da0f769eb033adff55af1d561def4928c62fa11f3c9845ef0e1ff42"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5e9d0eb9590fe2e290752e9124961bb84ea933b9d323ca4e877f68b52ba32d62"
    sha256 cellar: :any_skip_relocation, monterey:       "d93b38e5ca16cddb190b53be481f1125419c97d174f0379895762c1dfc71c3c2"
    sha256 cellar: :any_skip_relocation, big_sur:        "093579da0f00561e64ae79e48a353c3cc9c38992856a53eac53ee0a5d881d493"
    sha256 cellar: :any_skip_relocation, catalina:       "674dc1acab4faef28bbb727dd4ac9f08ff2f4bf92340dbff882aad94960e1e81"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0e169ace9d2c22725bf5c80a33f4e6c081df5539a9e4fc384700e3e0c568dec6"
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
