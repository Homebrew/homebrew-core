class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/v0.41.4.tar.gz"
  sha256 "08d4e343dd465ba6cfcf9f5da2db80de01c923e4ff3a2ace98f4027a15f493b6"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "568b0c26bc94abe9171c9ae7942bc83b9a64888011175ec391921bbc6dd3cbad"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a90ec95b623aad549aea7637f384599691263f6765ae831b4302cbee782fe0b8"
    sha256 cellar: :any_skip_relocation, monterey:       "f8955831bea3d9c836b0273844f41b6ae27fa3e5f6db024bff14310a97d77a7e"
    sha256 cellar: :any_skip_relocation, big_sur:        "cde8fc489110a01e21ac61189aa6f20eff73a88ed86319ddd0b8e1330bcd6da9"
    sha256 cellar: :any_skip_relocation, catalina:       "80d5e31562547e3dc7c597c3d10abf6eb8a84fcd6e8c3a341668b692555befd2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9fb7f3c5845b80f6244069830420a5a083cd91fea58d14907368f94a8075d0f3"
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
