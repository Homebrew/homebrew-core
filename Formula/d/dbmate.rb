class Dbmate < Formula
  desc "Lightweight, framework-agnostic database migration tool"
  homepage "https://github.com/amacneil/dbmate"
  url "https://github.com/amacneil/dbmate/archive/refs/tags/v2.17.0.tar.gz"
  sha256 "624dbc8f6acf03f456b4cee21341227415fba91e2fa6c86a9f4987294518fe69"
  license "MIT"
  head "https://github.com/amacneil/dbmate.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f4317d9391f0300373965effeefc21a1034c77c84d23b019bdac4122ebc67976"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2d91a8a63f14ff871a80c0c99e9aa5213cc95af148437cc3ab84c44eec0de819"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a4dca2f0518acb8436df59183ea08889865978b0ed3157c8eff08bd902d181e1"
    sha256 cellar: :any_skip_relocation, sonoma:         "8a3bfa94aeda07685dbf5535c8dbd92f9fbe30df447f69cafdc7770f96cdd4cc"
    sha256 cellar: :any_skip_relocation, ventura:        "f909b991a07739189088b8c2bcdc0efb9adfad173e4182de67b3003b0ff46339"
    sha256 cellar: :any_skip_relocation, monterey:       "b7694cca7daf5b1fdc7fa66ddeaa419636e165c1776d3b7dd834162a8fea6a0b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eae0539cfc6273c48a727b8f282d1848d8f98f8bc9cb4c699ebf1ba286257745"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "-tags", "sqlite_omit_load_extension,sqlite_json"
  end

  test do
    (testpath/".env").write("DATABASE_URL=sqlite3:test.sqlite3")
    system bin/"dbmate", "create"
    assert_predicate testpath/"test.sqlite3", :exist?, "failed to create test.sqlite3"
  end
end
