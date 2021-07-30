class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/v0.27.1.tar.gz"
  sha256 "748619f7aed53a435ee3652a79221f8d15fa70fc97826ffe1c4744aef4e30431"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "661e484fab00dab809c1f00e4cf85f03077c20a9c7eb1ceec45b375fdf054a04"
    sha256 cellar: :any_skip_relocation, big_sur:       "978038d86627fbe3d593e002bf0ad1f0653b58cc94f4e367bf9bcf41d229272a"
    sha256 cellar: :any_skip_relocation, catalina:      "14923cf23afb965fff180f03bdb8baad9a6756b3ea39f698f231c76a0b6105cb"
    sha256 cellar: :any_skip_relocation, mojave:        "af5edd786fe50e40830a22980639451750ca208037ccb512cb603218ae5d9d60"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cd64664da573937c401253b8829cbcb500bbe7587fdbbb2c63f9ca2ba1f9fd3a"
  end

  depends_on "go" => :build

  def install
    chdir "go" do
      system "go", "build", *std_go_args, "./cmd/dolt"
      system "go", "build", *std_go_args, "-o", bin/"git-dolt", "./cmd/git-dolt"
      system "go", "build", *std_go_args, "-o", bin/"git-dolt-smudge", "./cmd/git-dolt-smudge"
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
