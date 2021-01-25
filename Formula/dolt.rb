class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/liquidata-inc/dolt"
  url "https://github.com/dolthub/dolt/archive/v0.22.11.tar.gz"
  sha256 "287dbdb477a36e2629a22037db001e763eff6864cedf57c6cad744f6b7330b9d"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "dedbd60196e6dbcf5df6900b9f22d355d363b685da0b65102e1a0f302c355ec4" => :big_sur
    sha256 "b2e52a420b39002542bb7b1e36685bcfe545cb8b682ec67372fb519248817146" => :arm64_big_sur
    sha256 "2ce1fe2fc009c4f8198477cf18429042e34e7df34ed79ece08d858991a9ed405" => :catalina
    sha256 "97149bea3df37c6ed61263fe889c6fdac1bbdfee7e4c09c94ffd674e2b3c80e3" => :mojave
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
