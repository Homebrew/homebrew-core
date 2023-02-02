class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/v0.52.19.tar.gz"
  sha256 "7862c6827088d84cb34c55a5040247c397e555a6ec3ff0f197b83f25a384668e"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "feeeb9cec24b049ee7a407c0f5c91bfbc09cd5dfb93cdb29fee264fb5bfe09bd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b4cd802beae5c691d6078ea881f0f17ec3736e2bcfd2e8a5d2acb99d232f6e53"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6bbd78bebef44bafeb912d4c4287ec88a5f72ba52c2be67a49feb5ac62da0e54"
    sha256 cellar: :any_skip_relocation, ventura:        "e4d51ebcdb51516bb07c3c433a02237ab2bc909942cd57066c1c2860125f16de"
    sha256 cellar: :any_skip_relocation, monterey:       "5f5a607db7ae6a4af3a72b586fec7d7924bbf50d8d38c9b5c37cd55ba1a703c3"
    sha256 cellar: :any_skip_relocation, big_sur:        "399717005610465956d7a245291f8915b694cfc32ad19d5d90aa69a27ed4be0b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "19c7609ce02444c868158c53039973ccd408f74673d464707d516479cd62e2c6"
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
