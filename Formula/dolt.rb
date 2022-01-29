class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/v0.35.10.tar.gz"
  sha256 "7f4dc2721c9e6b7c6e1200d17fb30f91e6f1461b66af8dd5721795d4356c3bd0"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e96ba7a574052648ed4e64047cd810bef5b4f4285c66a0f8cf5bf59a26017764"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "01e309373c6eb2fc21fb43b1b9a2c18053240c694d4aa759d55e449a01814b1a"
    sha256 cellar: :any_skip_relocation, monterey:       "ec5a04bd44ccc4d9f9cd373b15eb76fc62573fb1e4d93d7f6e50f97df3dc6f23"
    sha256 cellar: :any_skip_relocation, big_sur:        "d6ea178b7f72c35c90612b534f18b4bf602f284d0b4e582a911889ecb58cc228"
    sha256 cellar: :any_skip_relocation, catalina:       "b7c3d5ffd30db207455c46d7af92a597d75041ed02c00e8129639b5e8a365898"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "39e08b2aaeb57dc7391ca59001f6ca84a66465f1c1e5bac7f6deff5d8c3d34af"
  end

  depends_on "go" => :build

  def install
    chdir "go" do
      system "go", "build", *std_go_args, "./cmd/dolt"
      system "go", "build", *std_go_args(output: bin/"git-dolt"), "./cmd/git-dolt"
      system "go", "build", *std_go_args(output: bin/"git-dolt-smudge"), "./cmd/git-dolt-smudge"
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
