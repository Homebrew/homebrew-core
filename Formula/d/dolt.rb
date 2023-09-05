class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/refs/tags/v1.13.6.tar.gz"
  sha256 "c6b5ef36bab002dae1fda9857f4c2e424403e2ba02f9c86b6d65c56a679eab59"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f41e9024b2256159e100be685fb1c859abced8cb3c87ff18086a437c727df4f0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ed15eded948d2497100d455f4b575bda031eb439058020b06384d99f78b70f68"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5141b3f183e3b210bec2b7b5b7a3606fff8530d31ce78a46f97596e32390377e"
    sha256 cellar: :any_skip_relocation, ventura:        "7f2de5008526e258fe21cc91a90d62a1d2fbadf5117a4d62514a1663141bdff7"
    sha256 cellar: :any_skip_relocation, monterey:       "39c09a6fb587f4d800c4ac572ef91b283e06705fa28cccc478c0b41ef8ab4a87"
    sha256 cellar: :any_skip_relocation, big_sur:        "4c322340867bfe6a7ea3d3fd8852a8f8ddc189bf2d8ecf75389783ecdf941f09"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e39e07be83f919f4346d687f8a9e648368f9f40687878dbb25649e41ad335be4"
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
