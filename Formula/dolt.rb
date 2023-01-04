class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/v0.51.15.tar.gz"
  sha256 "efc02550bcf0992a9947d24b1c322a08705bb48a402fd1c1b136d2a30fc302dc"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6d769cc9e44440c7da38938378ce2507334f7bbc3562bc3000812c5f86672605"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aa62b02f0552dc33c2fa4f50cd1f17ed58e23e89967cce4e7bda5b51d85751f8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3cee5d61cfc3a1d3db33f3bdea6e96096aa4332cba14c865d0e2dd0a4ecc827d"
    sha256 cellar: :any_skip_relocation, ventura:        "51e6ef553f57ddfbfd06285dca688e50900bbdbf93663cf5fec3b8ea622118f4"
    sha256 cellar: :any_skip_relocation, monterey:       "aa3237a214c0fe55469d2988b014ac7a993b307d3c686527a0f5ed3f97de8730"
    sha256 cellar: :any_skip_relocation, big_sur:        "bab1a1a709cea5c0229c844b22cc84d16a9aae8405ff2f3c37702da7c4c1bca5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "883d69a0dc4055bd5f916b460d5b451a957f0211f1fdd2d1c6a3c2850eb08bc8"
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
