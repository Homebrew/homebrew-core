class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/v0.34.8.tar.gz"
  sha256 "ee00ac61a427fe9d150431ca9b67c2b5a4140b714f8f92f29125e55144e6d13b"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ff35014f46450b749e94a23c0f819194d5dfd6813dd6bdf865e7dc38658dc69a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b875a7c15c8326bd03e35337e26ee8693f4dcbc6fa690958587c3626e3db618e"
    sha256 cellar: :any_skip_relocation, monterey:       "c6a59a1480ad722dccc204fccc91b2b39c84dd7c89e4e534521e04b5b7850d54"
    sha256 cellar: :any_skip_relocation, big_sur:        "017c69b6ea4dbe57989d5d86c8e995e8c1682de19353b40d0c9caa9d0fd69bef"
    sha256 cellar: :any_skip_relocation, catalina:       "db11c2392c904767eb29b5846ab8d7b23e6b3de994d141b2293c4b923851f7cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e467c82c955232206f0c80f5f8690db9ccfcdebe8588ca78b71b55b89412866c"
  end

  depends_on "go" => :build

  def install
    chdir "go" do
      system "go", "build", *std_go_args, "./cmd/dolt"
      system "go", "build", *std_go_args(output: bin/"git-dolt"), "./cmd/git-dolt"
      system "go", "build", *std_go_args(output: bin/"git-dolt-smudge"), "./cmd/git-dolt-smudge"
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
