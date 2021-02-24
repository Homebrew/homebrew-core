class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/liquidata-inc/dolt"
  url "https://github.com/dolthub/dolt/archive/v0.23.6.tar.gz"
  sha256 "41caa8529ba396c6b55c939e5419e680397b95e4015d7efb02d13e3bca90ac30"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "8d0cd8a53b83fc55bbed152ca4eaf19156fe3a07cdb8c671338dd430ffa48c93"
    sha256 cellar: :any_skip_relocation, big_sur:       "2f9829f2524c78a7ccbd9e16a21f695770669d5aed8f89d64704a19d2634350f"
    sha256 cellar: :any_skip_relocation, catalina:      "f32e77d71cd29a5b7a1627ff422e9682bff34f60cb0e02841ba6581830de2040"
    sha256 cellar: :any_skip_relocation, mojave:        "4985ae0133ac93b3cedabb6031002361910a9591b119b9b8d85352ebaeaed239"
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
