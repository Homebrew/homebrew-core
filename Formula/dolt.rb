class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/v0.41.2.tar.gz"
  sha256 "c28ff0adb430025a3d479ea8020bdc10412b498ad14875298e7108c65984c0b1"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "399a7a14666b5bc363a02365b6360e8a779676f7ce70c4e456aefe0b9ee51e4c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "daaf3f10949e76ea91295cd57b6f2484373041141403d74dfb97a181a54ef352"
    sha256 cellar: :any_skip_relocation, monterey:       "2b7601419789c8d5b3816f6bc7b5006f074e67f5c0873fee80acc9fcdf2225c0"
    sha256 cellar: :any_skip_relocation, big_sur:        "90edb7da060f8ee4e6b4cdc36a05263248d22724c792e819bdcd68631afbaa29"
    sha256 cellar: :any_skip_relocation, catalina:       "359ae091d9cd1dba385fc8de59b434bd978a654f9e3cd36a36e22e216783784b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c48caede53ceb9d1df24750070428fda1662f5af8e5cd87a6d4cfe006af1691d"
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
