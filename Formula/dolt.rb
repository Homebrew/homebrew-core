class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/v0.51.14.tar.gz"
  sha256 "f7b0b600964862cb9a8b742802d09cb13cbc8a248bc29bb7ee617c2d8024e69d"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f1b9b2895553e69defde8e1198ddbf269c9036d0bc559902d01fb658588bd273"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c8fbf371e2bc875af5f61c25facd371a373a507b01d9011119a227a96952a1bc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "48d56dd08c97ef4ad51900912a41056d10a2b9869623e57c1af93a58b6ca856d"
    sha256 cellar: :any_skip_relocation, ventura:        "7e7d80e01e4bfe857cc4dd46c440b6e00bd7eaf489d1a0347a2cc212fec51376"
    sha256 cellar: :any_skip_relocation, monterey:       "764a4e48fba69f34bcc371d58cea2dcd93c6aee167a57c82eb6e41c8db5c69a9"
    sha256 cellar: :any_skip_relocation, big_sur:        "cdf53dc41be31f7757581a753ed37c1cb24f715f83cd2827bb07284d3a299f9d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6cd436557ea353e37d8a18dff9513c49f1e6c49bfa8357fdf0d05eff017faca4"
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
