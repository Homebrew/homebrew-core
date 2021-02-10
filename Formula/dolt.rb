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
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "23c859d0ee796c76202a6271b93bc19fb4f1756962e28eadc70c3ec718ec11e7"
    sha256 cellar: :any_skip_relocation, big_sur:       "cc4f6155a6ce177ab3f745422f9f5a5b396d862d5ec5d3aa965e46827aacb269"
    sha256 cellar: :any_skip_relocation, catalina:      "cdab17c9b8ba8fed282e63436b35cd00f35793358c77b562c1b019fe9be1b32c"
    sha256 cellar: :any_skip_relocation, mojave:        "fb65fdcb8ccebd099bd2ebf41c9540d279e334131bbeb4636c6c1e60e593efad"
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
