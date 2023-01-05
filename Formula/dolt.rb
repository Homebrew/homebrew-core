class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/v0.52.0.tar.gz"
  sha256 "0d084899f2c83357058a042f50faf93da9bce26b865b99d0058770595a9d43fc"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5a8639060a39418fba8980b6d69dfff47edf23ce043071012a9da5fe34507e52"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f350fda516870bc7f0c4ee9755e7f90666d540a1aaf99c3684422f4062001940"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5b753f17b792eb354577ddd8c500985da5c002ba0b4522f682beedf858ebbdf4"
    sha256 cellar: :any_skip_relocation, ventura:        "6af70d9fac665f3693c591ae152313a11e5ab98bc571452752ffa7fb6b0d4334"
    sha256 cellar: :any_skip_relocation, monterey:       "5f359959338eeaab91a7a570b5fa4f7961ef43cb937c36a907c9d20750256026"
    sha256 cellar: :any_skip_relocation, big_sur:        "2071befffe288124907157b6805ea0d1d7ca0e4c0092cb0e8c9e0aa7ae0a72a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2d7c8c7f44ca5393098136aff6e5c9160ec29716c3afcf08dd07983dcaa01c74"
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
