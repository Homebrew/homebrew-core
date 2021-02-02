class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/liquidata-inc/dolt"
  url "https://github.com/dolthub/dolt/archive/v0.22.13.tar.gz"
  sha256 "4b455a8284cb80b5c31311901500a83c263cb6bb27b1bf8919c4f532bbc395bb"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "be85e117d5e13110601658739d8013550f4109e24ea2db567048683559e2b010" => :big_sur
    sha256 "e604a813163b88bdb36353d3066ebd982340e5f991ab0c3bbd533b96c7aaa0aa" => :arm64_big_sur
    sha256 "6a502e4fd1f5d06ca97ee88ab94483b61379b6e343e510edc9e06084cd18547f" => :catalina
    sha256 "ca71a73df8302fefc627ecd5badc0329e9a470076e099ca0ca5e7ac54c0639b4" => :mojave
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
