class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/v0.34.4.tar.gz"
  sha256 "d8f5749eda342dfec5fc27db569e7e9392c4a2c70eded6c087ccd2b75901080b"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1f64d6015744b9dba00adf76352be86af60fb5ea8a56a93d893c8b80b4b4a9cb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "45f0566c4256460231a5af33611d8b985c99f9d50964894d560830d0a8706318"
    sha256 cellar: :any_skip_relocation, monterey:       "45eb0528ee3da2a23188833914be1020ad7d8121cfc0b6dc06c0f61bbe38f7df"
    sha256 cellar: :any_skip_relocation, big_sur:        "3af232721d0eee1aa1602904bb1e3def06c753628b80c9189fd29e9f64342cc3"
    sha256 cellar: :any_skip_relocation, catalina:       "4847ccac0569e27fc768331358b0e8107923fca686e8842e85840041111ff14b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5115391f85f6cdb2290f2f1bb526fac406d79bf587d3801497bf7e285f9161fb"
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
