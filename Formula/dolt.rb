class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/v0.40.17.tar.gz"
  sha256 "b96c544aa919d58387241d77ce1878bc39f8f4007a9d53be59a228200f3e43bf"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b9faf33fd8b49d5f55e76719da38f40bf14cb5104dbd89b69effc49532110473"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e0e054edcf70b8b76946c94dc8e170db3a5409cb8c1217dcc91c2a0d793bbf64"
    sha256 cellar: :any_skip_relocation, monterey:       "82b8dfb43759018d4c126db5bb138d7fdac3edb6d3054db649cf1a7821991a12"
    sha256 cellar: :any_skip_relocation, big_sur:        "c081eae8f9c35f0de67b4e8021bf393ec6a05c1946acd0ace7147b167a50e6a5"
    sha256 cellar: :any_skip_relocation, catalina:       "c5e28c76964e281acdc8089dd35ba5057135d479fa94a6397d249cc6f79367a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "80727b223db0abef977bef20c2876c54085206fd97fc4e37aa17cbf5942b30db"
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
