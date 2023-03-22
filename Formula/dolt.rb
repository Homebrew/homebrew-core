class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/v0.75.6.tar.gz"
  sha256 "c426d0600eb9207a2a46574a69d40da13501b4a7832f33829e01432f60ff258a"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f4c5599783965b71a9a8c7677227dc2d5846fa66d7b836b56c3206cfd0042a57"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f4c5599783965b71a9a8c7677227dc2d5846fa66d7b836b56c3206cfd0042a57"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f4c5599783965b71a9a8c7677227dc2d5846fa66d7b836b56c3206cfd0042a57"
    sha256 cellar: :any_skip_relocation, ventura:        "7fc29f6a5a94826ffc25d36fa09caf444b6a2a8b4e19bd80bf1e8a7e146488f6"
    sha256 cellar: :any_skip_relocation, monterey:       "7fc29f6a5a94826ffc25d36fa09caf444b6a2a8b4e19bd80bf1e8a7e146488f6"
    sha256 cellar: :any_skip_relocation, big_sur:        "7fc29f6a5a94826ffc25d36fa09caf444b6a2a8b4e19bd80bf1e8a7e146488f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1895604beae526dd19e8def2a5672051cec33f853774e11049a80850f3b30c28"
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
