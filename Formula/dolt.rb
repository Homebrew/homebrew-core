class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/v0.51.8.tar.gz"
  sha256 "b119d2ed40b9c5399aa097bcfb9e63977fb5ba9efda06037a47f5b249759aaf0"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7e4fd2d1c1e6cce9d2ffe313b2955c6a999e629c10f428561416b0e719818a32"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "58b14ad05ddf212254fd1de1a53d7674db6f672a80fdfc6784c3804bc2b2f2c9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8b68106b8e548d9c3d7d7f44224b23c515e7b23be6999699d51f2bd66b5c4e8f"
    sha256 cellar: :any_skip_relocation, ventura:        "4342a321cf548f3550bf80858886271aec8d0761431214356d5e7828ad06de7e"
    sha256 cellar: :any_skip_relocation, monterey:       "219451bed5e317bc7df1f8dcc6d832c77f22b675e207cca0b03a856cbbf501de"
    sha256 cellar: :any_skip_relocation, big_sur:        "9aa1498ceb98c141bd478f1a5a0d5ad118a14fdb05da9dfa6c2b6c8da8e31263"
    sha256 cellar: :any_skip_relocation, catalina:       "dff063176b4ead720d1312ec2208a9cb0bff7ebf79e22ec95f82490c0a916bc7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9e665cda947e65cdd62ca4475a7d9c8522f6b35bd7223c0303164895d0735016"
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
