class Dbmate < Formula
  desc "Lightweight, framework-agnostic database migration tool"
  homepage "https://github.com/amacneil/dbmate"
  url "https://github.com/amacneil/dbmate/archive/v1.13.0.tar.gz"
  sha256 "acfe2d57fc81bfe7a02f60ba995f10fffbf5e93df62d6f263862eaf2b79c5413"
  license "MIT"
  head "https://github.com/amacneil/dbmate.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aef7f9ddb8d783becbafc4ca64acd73f5d46de964d74d7c8b422b9800c822e2e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1b2d361283fadb11ec3f761fcc9cf9cc73ab6dd2eaeff1b25e1f4bfd6d827945"
    sha256 cellar: :any_skip_relocation, monterey:       "93f662bbabd6cb2d5defba87e4b8361130ee295cbfdfd304b3afdd6ac440eb16"
    sha256 cellar: :any_skip_relocation, big_sur:        "35733f4892d6f58a6eb2c6d05bfd0a4785f2fd7f12eb52dfeebc17cc6bb3c7f2"
    sha256 cellar: :any_skip_relocation, catalina:       "d6787f44ed02e998412e4a6127c6b7693f26f62dee3a8211d542b54e18352e23"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "44899cedd8540d78c9d962ef8df1e60c6b4a4e6ecd5ac03bf623e0986aa50cd2"
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
