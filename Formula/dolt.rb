class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/v0.28.2.tar.gz"
  sha256 "2c1f8a4030fc33ceb93cf5dee799a9725e7565a78f256da49ec51cc34a5f695d"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "585067b40e164ee89d4e62d5fd0ad6686f038da3ad59ea6460993fd2552977ac"
    sha256 cellar: :any_skip_relocation, big_sur:       "d46d78b6af300c691b89d511fb29a3d2ceb4d3a38e24f85359c2c56c4dcbc7fc"
    sha256 cellar: :any_skip_relocation, catalina:      "e505dde57b4fc4fa083c3545b8f1c4ca9671ec3947cb15d72599ecc2e40ec9f5"
    sha256 cellar: :any_skip_relocation, mojave:        "9366b0260956d092ffd2fff8b5e5295f46f9cf9d4bda09a7e0896da6a2c74b95"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "298ef9e0fae10d6212694ab45e451ea36c9c10645be4aa08d2c60366fa21556a"
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
