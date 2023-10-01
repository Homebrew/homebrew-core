class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/refs/tags/v1.16.3.tar.gz"
  sha256 "965dc875649a18f2e59ecabc15149b28c2cd061246f8b1333abe9ef17d3ea39d"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "722a7a6004cac5990d6e5dc6e5f60349a61d7c7aee79cd7fe59ce881559fd1c7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "546827254ce76c0359e7edcece0c4e55534d90e4eb5c686936dfbff46786207e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9b5fd452d8e6af991dff0b6c494af87508d1097a9ee83e68b0bc5baa70902b58"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "96096d7a23b977ba096e722053786c17c9ed1049c12895eaa3f87dff3d3dc2f6"
    sha256 cellar: :any_skip_relocation, sonoma:         "4191e712da2ea850e3c59b3f13526cb340fdf8a851b94e46a755d0051c606e53"
    sha256 cellar: :any_skip_relocation, ventura:        "f0c6a4557bae99bfc380f246bece90c183d66cef4f2a5ddfe59f070d06f54fc4"
    sha256 cellar: :any_skip_relocation, monterey:       "35fa7611b65aa3db859322dbf343f77a424dccbf407d78a79da829a9d924670a"
    sha256 cellar: :any_skip_relocation, big_sur:        "02156a69dd8320406f612c436c5e02146d26e9a1b3aa8ef6b7ef1340b7b57ea9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c3a7393a05000742eb6bbdebf4b8061c06d30046043bf7429c5cdd605972d72c"
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
