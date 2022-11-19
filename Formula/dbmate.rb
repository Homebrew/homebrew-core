class Dbmate < Formula
  desc "Lightweight, framework-agnostic database migration tool"
  homepage "https://github.com/amacneil/dbmate"
  url "https://github.com/amacneil/dbmate/archive/v1.16.0.tar.gz"
  sha256 "1b3feae085837bd21243ef1966e64536a837ee260ccb809323879940fa5df877"
  license "MIT"
  head "https://github.com/amacneil/dbmate.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "84741107e6a4ae2535a5ac79a41fe6f35ffce6b7af815053edd5ee7a013b264c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "883afeccd9b6ec5d556f6f464b649dcf892a101591c72850a1f0849b61ce5934"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "608fe9104738fee53cc2575ec83905352e90e1a7b130644aff0912d4232da8cf"
    sha256 cellar: :any_skip_relocation, ventura:        "6e7c0a8185fd2320499fbbe7bd326f72af65f128c81cb3bbad296942edb3cd8f"
    sha256 cellar: :any_skip_relocation, monterey:       "496b49b81b6f79263021d91dbecdac39df9553a087916fc5c7a8e59773399672"
    sha256 cellar: :any_skip_relocation, big_sur:        "6817c9225395174c7504486ea64a52995ec2c919078a4174f570c5b464a0447b"
    sha256 cellar: :any_skip_relocation, catalina:       "fa3aa15ff3782f200cea1aa55c56bdf6402de008dd9d10c26245c4c8e5a004f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fe1a071af2ac4640ba413612693103bc94514451e6538693adaaa60027efd0c1"
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
