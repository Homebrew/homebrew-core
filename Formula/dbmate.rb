class Dbmate < Formula
  desc "Lightweight, framework-agnostic database migration tool"
  homepage "https://github.com/amacneil/dbmate"
  url "https://github.com/amacneil/dbmate/archive/v2.2.0.tar.gz"
  sha256 "464b801a47bf86e95f40305c8cfcd230d34ef59b9f386e3c29eb2ee4fc9dd20d"
  license "MIT"
  head "https://github.com/amacneil/dbmate.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "158cf8922be101b222b408485c7699465d8b94e89a259a0d5e4f403c397849fb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ce157480bd3c7fe55f081d67ef4bbdec4aa610396dbacf0ed2ed6ea0c40d77aa"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c07ae7afa238615d2fef8f27150cd730c5a41f464141fdbdaae73b0e597187a7"
    sha256 cellar: :any_skip_relocation, ventura:        "d416b942400070afc0917bd675a379afb42cc8904809a250b556f2a71c56813c"
    sha256 cellar: :any_skip_relocation, monterey:       "2d04f6aeccdbef5f9e3f3a593d538ae06866ca39893c5d4f7763b8d4432dc1c6"
    sha256 cellar: :any_skip_relocation, big_sur:        "c800f3eb0d338218e58e72d9519d0e9650f7d390df80282a4ae570104dc44623"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "43b86de3ff1112c6265dca2afc8fd4685793a32f6bed35209d7ee3eee4464e17"
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
