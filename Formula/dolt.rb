class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/v0.52.16.tar.gz"
  sha256 "80f5cb560fa256a2c2fa6aaac2df5fdf0eb6501b2bec98713886df6133a05997"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7e197a35c6fe5f46923c61208c5a3e5c181523030e8e134dd27e8a0cd4f7a797"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "89443f7ed209b2405f8de3f0090ba87e9bb10ada6f52ae3bced56d40e77928b8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4ef678bdb55c048d48192e2105df37fb37ffddb0746dde054776b25d537d9357"
    sha256 cellar: :any_skip_relocation, ventura:        "57cbb854ad9a7315351390b8fc6e7f1461324b99a1eec2b0224f0a7d19ca53d5"
    sha256 cellar: :any_skip_relocation, monterey:       "bfe61253abf3a9bb5d7c4911396a3a99df7fd40e60eb11fedb8869028c75db75"
    sha256 cellar: :any_skip_relocation, big_sur:        "5007461271302577841e0ecb32db06f5662534c5c06100164a281c925830de82"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d94481e9a27fa3f09904ef7586a96a7cd414bcb631a702b266f487b626154b08"
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
