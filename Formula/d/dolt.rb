class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/refs/tags/v1.35.6.tar.gz"
  sha256 "60bc4a8f122b7f0d3e124ad4291dd2f55877314b59784773806395eaf89ecdb7"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "138d9261c09bca0d053cab122bb7cdc08adf55857a50f80577a4e488459941dc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3ebf5df2b1579955cbdd607d7af5a14323a3c98076edd97b9d3e23f893d717bd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "932ade40c3f3fb933673853f0ab3a10e7c59a279071e05e7bfa07da365bbd941"
    sha256 cellar: :any_skip_relocation, sonoma:         "08c89b3ad511060513d974b1eeb2261d2fbfe708d17021e3d4c37133802d42da"
    sha256 cellar: :any_skip_relocation, ventura:        "4e0f0c24e54e41b46fe5a1eb62c68688a3886b3e3604c65d45dbb54beaa4d16e"
    sha256 cellar: :any_skip_relocation, monterey:       "a477d68c88bc851efb1f84cfa417088d6cffab848f0688ea6064c2ad52f55404"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4d1a53fe5f1106897c9cab797406530fb72f4cf6fd63f4f39397176b3e5c9dc7"
  end

  depends_on "go" => :build

  def install
    chdir "go" do
      system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/dolt"
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
