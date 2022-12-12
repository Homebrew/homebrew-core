class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/v0.51.12.tar.gz"
  sha256 "59516a1c9dc887961cba6cc434360f0c456ffc9e979cf141c228f412472a2c8d"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b5c80a06254ec8397d5d487519457d5caef07c7dabc625a914d3df2a1f0c8a63"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bc04ac80e9313de39da2a41dee5988ac764ebc0a6bb7b4d87ab3e7bf99471ed1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "33c71e018d99b75a12fe1272f689c47932dd4cbb44404a7bbc7a035ed29726f8"
    sha256 cellar: :any_skip_relocation, ventura:        "ca08334210020a9e923867d6f5dbbc72a5d9ff7b1a70679ea1e5a1e650383c0f"
    sha256 cellar: :any_skip_relocation, monterey:       "11f06b1342b3550fdc17ce0218824d212272dccc8e08d62f32ffe5350be2c2dc"
    sha256 cellar: :any_skip_relocation, big_sur:        "50734b404ad13dfa7a3584ee2cc5e5251ad4f4e3d391ed04cc7112da140742b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c506eb9f23861f0e02d8f57f213bc9b1dab276cd3c97dd8bd44e8a267e71ea84"
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
