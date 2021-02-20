class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/liquidata-inc/dolt"
  url "https://github.com/dolthub/dolt/archive/v0.23.2.tar.gz"
  sha256 "87976ee34988d068298d25fad64a5518877c0bd70a5a12df5bc48c9f0e3fef93"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e6e99b274c314ef98af96b59095defd1f4c56ec3fe1ed5a97a2c7e12715d9700"
    sha256 cellar: :any_skip_relocation, big_sur:       "b7bf38fb35d97f600612e95b3a5bb430860fc4bf589452734fb933bbe6ae5d1e"
    sha256 cellar: :any_skip_relocation, catalina:      "34abe4cdd02373a0002a08a4a1712edfc3cc1a1316afb007c26bfb550d47f734"
    sha256 cellar: :any_skip_relocation, mojave:        "17266fe30602b15a29f79f80e780737add038d175d77c66a5f4bdabe7625da03"
  end

  depends_on "go" => :build

  def install
    chdir "go" do
      system "go", "build", *std_go_args, "./cmd/dolt"
      system "go", "build", *std_go_args, "-o", bin/"git-dolt", "./cmd/git-dolt"
      system "go", "build", *std_go_args, "-o", bin/"git-dolt-smudge", "./cmd/git-dolt-smudge"
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
