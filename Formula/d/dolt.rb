class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/refs/tags/v1.35.1.tar.gz"
  sha256 "c14d03154442690167eb06332cee1edf2dae99c191115bc30838f697078387cb"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "eebb076095e089ea65bad7e8d118c44cf4743d5cdc4c1b08f0a3043eeb187478"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "77b7a2968f627d8799aeaa73169c9b6a08f5269608084137e72b6ea26e0febb0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "75687975a8295644acd119250589dc2bd758cd8c23018c1c3f415d84bb4bad7e"
    sha256 cellar: :any_skip_relocation, sonoma:         "2ed9fd53749be678c0257b7231c989fb718b5971b451045cedd57ee010e8b4ac"
    sha256 cellar: :any_skip_relocation, ventura:        "d42b29f1e03a2758d10cc1a3db80ad785c5685ece84817636045a983cb6e1f42"
    sha256 cellar: :any_skip_relocation, monterey:       "40123855cf2716d669577ee4dbd12ad55baf37df27a69fc998898be659181d6e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cb6198f509b80d88325b3d742e5e252b4d6d6bc2c5bb59f7bf015d9e5633f0d5"
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
