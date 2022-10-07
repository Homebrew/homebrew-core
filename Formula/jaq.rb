class Jaq < Formula
  desc "JQ clone focussed on correctness, speed, and simplicity"
  homepage "https://github.com/01mf02/jaq"
  url "https://github.com/01mf02/jaq/archive/refs/tags/v0.8.2.tar.gz"
  sha256 "ebb25a176925492909434919000a54f1592b3488c57fa83bfd324eb1fd71e9f5"
  license "MIT"
  head "https://github.com/01mf02/jaq.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1592152e79a2ee1c77315ef5dc14cfeb279fcabe673d1f3eb71273de454d0668"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c5b4985869d8b7120c971044b65d9be7efdb3e5dc95a47550d301ceb255114d3"
    sha256 cellar: :any_skip_relocation, monterey:       "0c1f5c32acfab2b9d866393ed79007a9e4bef99d13d93e6acbda1e42a35718a5"
    sha256 cellar: :any_skip_relocation, big_sur:        "d0ed3a5011ead1161f4f3222ee644a8a7b824bc203b2e26e055677d5927c2131"
    sha256 cellar: :any_skip_relocation, catalina:       "41c68f33b71605b1980d0cfea9388113fcb29b2c00da23f2ec57db9ce1d63358"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b1dd049dab4ee712390d44775eb3341df224947cf57452c165520d8ddf74db12"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "jaq")
  end

  test do
    assert_match "1", shell_output("echo '{\"a\": 1, \"b\": 2}' | #{bin}/jaq '.a'")
    assert_match "2.5", shell_output("echo '1 2 3 4' | #{bin}/jaq -s 'add / length'")
  end
end
