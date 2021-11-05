class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/v0.33.1.tar.gz"
  sha256 "a912b699271ea28d09ae77cb517b377b3a6668fbe947557cbb10dfabb2a6aeba"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "308b4ad8bf4d8ca3e31842db088213caf21981b5dfb809b4ddfe1ecc8c0aac30"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1532a2b21dd2323539658926681d5626711b89dae0e06a7b167b0459df875d98"
    sha256 cellar: :any_skip_relocation, monterey:       "c43d527f31ba89fc8c5819d586dc5e968632daff099db1d05583139d3c82c40e"
    sha256 cellar: :any_skip_relocation, big_sur:        "2e08c7c083c32d4001c3ca837e1ab9dbf218fe9554e85ad7e69ee1e62edcb5ba"
    sha256 cellar: :any_skip_relocation, catalina:       "50b36b8886d418c0dce6f4c92d03496dd4abdf7b95349c5fe703700e8c66a145"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "728e512ff8a8d66e2d8c741fc8a572131a0396f77d36a544e4e3a681f2318fd5"
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
