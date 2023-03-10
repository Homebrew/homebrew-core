class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/v0.75.1.tar.gz"
  sha256 "6627b35f7ff60dafe3c9197172da1f2d233dd207cfd8cbd248f929195d695477"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1efe4b75c1fef44ad8bfdff9865cc52c328808d09ec1e259be82446636321c80"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1efe4b75c1fef44ad8bfdff9865cc52c328808d09ec1e259be82446636321c80"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1efe4b75c1fef44ad8bfdff9865cc52c328808d09ec1e259be82446636321c80"
    sha256 cellar: :any_skip_relocation, ventura:        "573334a252d5167f9e57fe6d0e57ae30a14991da4b8c9a3083ffb806be8de451"
    sha256 cellar: :any_skip_relocation, monterey:       "573334a252d5167f9e57fe6d0e57ae30a14991da4b8c9a3083ffb806be8de451"
    sha256 cellar: :any_skip_relocation, big_sur:        "573334a252d5167f9e57fe6d0e57ae30a14991da4b8c9a3083ffb806be8de451"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0dfbe633b581d488058477d12b6844fd2a121622ba2561c813ea1014e183e164"
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
