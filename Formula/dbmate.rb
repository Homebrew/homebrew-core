class Dbmate < Formula
  desc "Lightweight, framework-agnostic database migration tool"
  homepage "https://github.com/amacneil/dbmate"
  url "https://github.com/amacneil/dbmate/archive/v2.1.0.tar.gz"
  sha256 "c48939c345812a9b87d6f97422277c0bcbb8d84aa10612efab7f964e68dd6310"
  license "MIT"
  head "https://github.com/amacneil/dbmate.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1401907b4e8f4cce9cb43efbfa93490a7d7526c82c5ce25dea027a4afea57eaf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4be2780f1e9b756c1c166660350082888b5ac0ae111d04d8711f16dabd6102ce"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "47162e3eb3acac29c56580067c1459a16bdc3a4454af342514050a7dc33f7268"
    sha256 cellar: :any_skip_relocation, ventura:        "bd577bc3adcf5c3dd40e5b389960b60136405b7c8afd825117bf7555b3f738b9"
    sha256 cellar: :any_skip_relocation, monterey:       "e293d6b8c5e1258a3c7decce4c38a097f37df006716f570f043f4f2f0203f19c"
    sha256 cellar: :any_skip_relocation, big_sur:        "886a5c3837c0446a946f316191719d5e769b5e9414e84af555ca868f1a193b5a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "20985f6cd417d42a8ec875ea708322a7cd4329f5980718586f414999a83dd003"
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
