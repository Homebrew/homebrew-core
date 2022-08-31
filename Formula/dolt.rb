class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/v0.40.32.tar.gz"
  sha256 "9ac7f6f0381b3002da213ef4148a9b98fe3b7e47bab8362f6a12f985123352bb"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2a719aa3efd9aa0915a405f401338822dfb61dbc646f682d497be650d9d7cd40"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0b0c90cf659f7310cf81dfffc35d721ca26d0c9f20e9717da048d42cb24f1937"
    sha256 cellar: :any_skip_relocation, monterey:       "31ff4dcbce0ac3aa94da606d866a8074a4e7e139925159b1e1be286fbeed850c"
    sha256 cellar: :any_skip_relocation, big_sur:        "81a05020dd1ac64c047acf1f59eb5c21a77abd46baf10ae8e10de872cf0223ee"
    sha256 cellar: :any_skip_relocation, catalina:       "1a69f63005704a0efe70c084c3cd2d702dde15e405eb23d49c0da186cc4d7420"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c2b30d145cb68e80d76886e9232cdedeb7b1c0b27a583f463b91cbf573988191"
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
