class Dbmate < Formula
  desc "Lightweight, framework-agnostic database migration tool"
  homepage "https://github.com/amacneil/dbmate"
  url "https://github.com/amacneil/dbmate/archive/refs/tags/v2.15.0.tar.gz"
  sha256 "131d4a83bc507818ffcf6300b5cd768d615954eedd58fefdb64e4d3639181a88"
  license "MIT"
  head "https://github.com/amacneil/dbmate.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d7665057e111f2d1e3b4e692c5a231246753d08d6537417356d6e399257760be"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "870a21cf2829190e41be1eac909e9e203f5ecf2fd8b2368d57686ce304156fc9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "01915427da8eccf503cef55d5fd8ae5677304b3297588152849a4ee7487a2bc5"
    sha256 cellar: :any_skip_relocation, sonoma:         "f8c09755d6f875f972ea70b13a00bdfd0bb37b479786c961a2699bde6ac139b0"
    sha256 cellar: :any_skip_relocation, ventura:        "e599e8b8de8335303ca0be88cfa07beed3c48ce6cea23773bf7b703a7eb51706"
    sha256 cellar: :any_skip_relocation, monterey:       "32afb19e68c6cc91b95b3dd2499ec61c7e8a4546a0420b5768f24b666358f987"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8b599a6eceff0f2c98bacedc96a1dd39b9736d684c62def44be6f469b9683ccf"
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
