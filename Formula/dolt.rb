class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/liquidata-inc/dolt"
  url "https://github.com/dolthub/dolt/archive/v0.23.0.tar.gz"
  sha256 "2fb7456f6c21fa750778fc5efb6a959f527a0d86f63202922803afd3cc469f44"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "7bb5b6c966ada6d17a2eb70c7c343bb6f76b2aa7a38530b6e1e9442ddf8ab026"
    sha256 cellar: :any_skip_relocation, big_sur:       "97e1f1ac47bf77596cbd3f1cc0f1945332faa49603eb6ed7cbea972582818ccd"
    sha256 cellar: :any_skip_relocation, catalina:      "75e3e0f913cdf22d2462d59335b71b13173f4f77ea3e3f1ada36089e6a3d4060"
    sha256 cellar: :any_skip_relocation, mojave:        "95653a237c645a496ed03bace316409e571c4bb305de50373ea3c13b22f08141"
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
