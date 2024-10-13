class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/refs/tags/v1.43.5.tar.gz"
  sha256 "cfbab08d7845cb288916b3a629b9aac135536f28acbec164980a52ab030c6fae"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c0411547ba6a7c7266a46055729c994042152b777972f776023bc4cba05d24fd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1ff18327ebdd3dc0e6adbd332ad63e07fee9ceb17c9422c6381c1be9a34138f8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6d8bbbd0cd1d875d38e06881c7d616a86d66d04465b1020c6863fc484528fc21"
    sha256 cellar: :any_skip_relocation, sonoma:        "33bb89fd233ef459bf9892dd6eb781cfa40a9b374aa9d6fabcd9faf25156d8a5"
    sha256 cellar: :any_skip_relocation, ventura:       "5829c127996454c065dd01ae3fa9615192ffaf74ac5e4631028cf6bb1fceaaae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f6ca40a8de678bb626d3c539e019e61c2fe0ea6967c95bde93f2eb736f362e90"
  end

  depends_on "go" => :build

  def install
    chdir "go" do
      system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/dolt"
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
