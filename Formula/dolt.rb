class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/v0.51.11.tar.gz"
  sha256 "31b3eb63e6f8ff0b3d1f76869d4c8eef7e73e5eb1400fafef710d7f3e12e21d6"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a3b466312b5d8aaf8cf057845c973a83ef3b2dfd1f149cc4a5a63364ef0001da"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b62ac95455228d0318733e74175bc80b1df06d21679a51767adfff81fb1936f3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1f4b20c7a4bf0a83b05c1dbc33e1c9e79bdb5d5dc8d5bfafa805d75eb02e711d"
    sha256 cellar: :any_skip_relocation, ventura:        "e94c560aab393ac2528f78b8bda218f7968348ec621d0421823a0a5750555fa2"
    sha256 cellar: :any_skip_relocation, monterey:       "bda9410fc55bdd9075c60c3c5cae8738176a97b5e21b309bd9b640951da44cce"
    sha256 cellar: :any_skip_relocation, big_sur:        "cdcdf2bdefe3247ed3e27304807fd57526664234212e37b0863a3806c592d3ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b61ed13bb3e164bcae7c44981d3940dad8360aac8d168c3b5b25c21701a60bf1"
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
