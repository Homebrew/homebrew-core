class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/liquidata-inc/dolt"
  url "https://github.com/dolthub/dolt/archive/v0.26.8.tar.gz"
  sha256 "d408ac7e41bf3b68a0a7732b1053bad8c4b93f658c500cfc2f726e23d7861ad6"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "b0546e23fd78748a041eeee400536e11acbf47b1e3b1f64838cab406b4faf31a"
    sha256 cellar: :any_skip_relocation, big_sur:       "e670efe41bdb8730e18f9a7e184a0286dc172e47c556ea9574e8f424cfb54157"
    sha256 cellar: :any_skip_relocation, catalina:      "83f2766193cbcb7575d164baaf4090fc879f40a33179489b577dcf585d727b3a"
    sha256 cellar: :any_skip_relocation, mojave:        "a87a450b6ed3186019cca3748eb089d086faf090508cfbdab836956bcc31b7a2"
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
