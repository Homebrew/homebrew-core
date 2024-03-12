class Dbmate < Formula
  desc "Lightweight, framework-agnostic database migration tool"
  homepage "https://github.com/amacneil/dbmate"
  url "https://github.com/amacneil/dbmate/archive/refs/tags/2.13.0.tar.gz"
  sha256 "626dcd6c90c4be51944462379a8e4b118050f8579b5f60433adcfa13974651f2"
  license "MIT"
  head "https://github.com/amacneil/dbmate.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4b39890879dcc7f2238e989ceb0623e553c9a156a8261acf84e930d6d98ae270"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "858b7d1bf3a3fd553cdcf45bf82a26f9c6285e46916233c04b3d6cfa1f6487d3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "267de2a70f9c1d18d205ef11d424c43798d23ec75aebcbf31bdd1b59753e5f15"
    sha256 cellar: :any_skip_relocation, sonoma:         "b7737eadfbe1c06c57f91af06606a67f7a8b967bb1cca7158c70a0395e756db2"
    sha256 cellar: :any_skip_relocation, ventura:        "0ebb99efcd00424e99a636b026772c041f4b549619a682f915ccb19f89e3fb48"
    sha256 cellar: :any_skip_relocation, monterey:       "61e35a85276c63f9e4ddc09f7afee4d41a2f20df660124c5b2606c9264166231"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7c664bf524f1ca3e140b245577e4df46486a8107ba2e18149da6e303485e881b"
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
