class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/v0.50.2.tar.gz"
  sha256 "f0d1e83b207722bcbe2f5c61ebf35e67888246ba99aa3596bbfe473cf83c0e9d"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3ad26098454a0c8045d8ff4b07d72333d14cee67ef04062b9df3776d737222ef"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1d04678d2e8b80c6ce908944dbd4f11e7dea9ad7113dcc9c4831acd387c07e2f"
    sha256 cellar: :any_skip_relocation, monterey:       "f5331b514bd2b857e1537375c81ab59c45f32f834082fbd4dab13394474d04e4"
    sha256 cellar: :any_skip_relocation, big_sur:        "e60d60e5666bb3418b4ca549651a988f422b1d97ed5e2d60537d79c0c01ee837"
    sha256 cellar: :any_skip_relocation, catalina:       "e5b8ba913c8926f233a49f790316730f46e068a46602643e7608eddd17e200af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "443fb5ffcbb11f75098ddb1d07acd6ff7d5c68ae9d560ea8c24173dc090b4644"
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
