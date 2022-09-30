class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/v0.50.0.tar.gz"
  sha256 "29b0fabc471504b6945808ea5ef3d8ca8132782f9d52324fe5d5c5ca9116a003"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7d98a6fddd95f7d047f249da42e6ea09c382d7aa49aa9581d0ea589c2a66b66d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "115097993ded6de42bd967411d02b477d1b45ab569fa4645de0851f0d86ecb44"
    sha256 cellar: :any_skip_relocation, monterey:       "66da31982b4b086e11eddddc026bdea579d33a2c0609de404e61765504dceb27"
    sha256 cellar: :any_skip_relocation, big_sur:        "576324d653a53eb44ebe9ff94999d0e641f9886ed7b47761c05945fbd2f5edf5"
    sha256 cellar: :any_skip_relocation, catalina:       "848c0975d87a57a79ae65eb9019106483c3afb9123a27ed18ebdbacf9b42cca0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8e527299dfcf34cc450451e562d7af679ea3488e6e3300135aa7119a5bba4b5d"
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
