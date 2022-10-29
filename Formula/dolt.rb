class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/v0.50.11.tar.gz"
  sha256 "5ddac02a82480225c1560d511641ac8b7eff93fa6b87a050ce2969887f0c2571"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a4b8d6144507f50ae8c03838b11e27643011511c2cc367c8f75a5809eb7bd2f7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5bfa5373a5c4be46a9ba82f78c3a25690635bd558386b1a1a9d311521dea5989"
    sha256 cellar: :any_skip_relocation, monterey:       "995e6d85e0548a9bc6172969991b79fdaceec8721f36c562a58de35cfa31f0a5"
    sha256 cellar: :any_skip_relocation, big_sur:        "b13dc5dd8b9bd4e9bb8916a715961e7655b0253287626453cf398c8d53cbc04f"
    sha256 cellar: :any_skip_relocation, catalina:       "ba238136f7cd972fff762469bb7b01663b679d90a56c3a81d9428dc746b3f913"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5ec337e8fd1c22a21e9fdcba031c87cebfa01cc55c61d8b6f12bb184cdaea69c"
  end

  depends_on "go" => :build

  def install
    chdir "go" do
      system "go", "build", *std_go_args, "./cmd/dolt"
    end
  end

  test do
    ENV["DOLT_ROOT_PATH"] = testpath

    mkdir "state-populations" do
      system bin/"dolt", "init", "--name", "test", "--email", "test"
      system bin/"dolt", "sql", "-q", "create table state_populations ( state varchar(14), primary key (state) )"
      assert_match "state_populations", shell_output("#{bin}/dolt sql -q 'show tables'")
    end
  end
end
