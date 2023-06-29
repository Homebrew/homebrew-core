class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/v1.7.0.tar.gz"
  sha256 "5ca0efb846e35217553f65014f242d5e8c762bc136bd9bd859030856bf086e3d"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e7ebfa9d6db781b168aa10792be41501ecaad0a2525c8e0ca448aeb834e45020"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e7ebfa9d6db781b168aa10792be41501ecaad0a2525c8e0ca448aeb834e45020"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e7ebfa9d6db781b168aa10792be41501ecaad0a2525c8e0ca448aeb834e45020"
    sha256 cellar: :any_skip_relocation, ventura:        "4ab9559965c56e02d4b5a439f287c384a03373bca6795400008be8497fac1b2d"
    sha256 cellar: :any_skip_relocation, monterey:       "4ab9559965c56e02d4b5a439f287c384a03373bca6795400008be8497fac1b2d"
    sha256 cellar: :any_skip_relocation, big_sur:        "4ab9559965c56e02d4b5a439f287c384a03373bca6795400008be8497fac1b2d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a2be38ccc399d8b501b203f64114bd59fbe6487d214b709bcb6cc8982521e174"
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
