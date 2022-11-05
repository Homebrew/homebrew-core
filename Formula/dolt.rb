class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/v0.50.14.tar.gz"
  sha256 "b1e21dcf5250ce8fc8ade7baad625b8150dbd4ddeaa2183b65a3898829cde0f4"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4a8dc70df0756b48195391a8d2587c7decd65c1606550298ae04b025355111b2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "591b54b71e86d1241d52f4905197b578907ba858a989a1ad3e3e605a6b748888"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b59b4d64218beec71eb2d90c6016546f16e07adce55e9a8dc0f01e85982b8a76"
    sha256 cellar: :any_skip_relocation, monterey:       "76b4c5861f3d68836cb64e63f7e25b3ce12de2b24f5823131ff232635c15554e"
    sha256 cellar: :any_skip_relocation, big_sur:        "00e584a6c1e9b93f9b8c9489224041ef2a1af6984c6db69c8d5d87f27097e961"
    sha256 cellar: :any_skip_relocation, catalina:       "97bff30c1dd2cb3e0ab49304c4b48d8191127a822b4e0de6224213a8d9bbae08"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cd36628e63242e1da2c8a9c7b564da53cc9c7d872b14a1eb6e5b06cb4fd3e9d1"
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
