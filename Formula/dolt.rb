class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/v0.51.5.tar.gz"
  sha256 "3a777028dd34299761a105783c8d62db38c3e5bdf5a652b4a923a4eba98e78c1"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a68171218e4a49b0da7d36826cb70256579ec094cf9805a4a71cfebbb2e6c877"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ae9fa4bfea48dd151f6cd394a11f3a7d22f3c2c52f660dbca80f742deff4d3cd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "46854ea14b5635617b25f2d21302ab1d234e0d669e31d71fe4035d4cdbd37a9b"
    sha256 cellar: :any_skip_relocation, monterey:       "d02a3f8e6f1d3c5c7ae2e4da1d7fa819bb616ec440547e00df9ed7b2bcba7db3"
    sha256 cellar: :any_skip_relocation, big_sur:        "06185f8efd2af191650a146d6bbe0acb8bd70b72dfa98b717fb8c26958c7279d"
    sha256 cellar: :any_skip_relocation, catalina:       "ee15276f834feefeee899690746849154090fde9b1c5b473826538a79ad89446"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a33e351ba3b0564b9a54f00ec149516c953b7b4ac52e688925814e5d21b6f19e"
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
