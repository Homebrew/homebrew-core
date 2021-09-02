class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/v0.28.2.tar.gz"
  sha256 "2c1f8a4030fc33ceb93cf5dee799a9725e7565a78f256da49ec51cc34a5f695d"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "c965cf205ca61ee916b5ed9da41e84f8f82b74c674d043e1cee33d76c45dd4bf"
    sha256 cellar: :any_skip_relocation, big_sur:       "5521ac8c98317e15c5c5d1da8f0282a26b44ec29749afe705cfc048bbf226fe7"
    sha256 cellar: :any_skip_relocation, catalina:      "60f16031556861e133fd58aa2c0478c6bce399637f7677c6e26316ee707f5746"
    sha256 cellar: :any_skip_relocation, mojave:        "735b3faaab38d2c95be168e78a087e99c4f3398df2c618a7c58b6b035af13f11"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "34e1021160b580dbb4d01a0740c435aa6dca906453fc6537da51656dbf4b70c0"
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
