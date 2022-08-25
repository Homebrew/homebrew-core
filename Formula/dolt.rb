class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/v0.40.29.tar.gz"
  sha256 "71e081f79ba537fcbf47e80124224fb9a27b8772b30fcebe88db18fd6d97c2cc"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b16351ef6e09f3dbd64fa389ee8838b37e9ccdfdbf68508e00fbbc029791d86f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b50aeacecd479b4403ff02031bb77e187112b94c6909628b5a3ae2263ed1c6b2"
    sha256 cellar: :any_skip_relocation, monterey:       "d0697eaca9a45e729e69566463f960319c0b386b5e5103c9da94385ec87f944c"
    sha256 cellar: :any_skip_relocation, big_sur:        "937cb8e3a34390c9bde35d32cbf3d58b89a38fc8dfdc583148471b3c5dc64f16"
    sha256 cellar: :any_skip_relocation, catalina:       "e23ec1c073558334547d4f129e5153c3b814de678babf65cd350d0fb702649a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "438b2e4fa31f75b9f011751e7e8d984ec867b838de50a03906dd32d356da4b14"
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
