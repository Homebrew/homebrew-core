class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/v0.34.0.tar.gz"
  sha256 "28df295e5d5d8e6a7244392881cd4dca7649c22641a7ee789ea43df0db769c18"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bf9135626c9af63b5fc3afe2f731f3dff1b701185bf533cd5ceaca6179f5a60c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d712e8a9056b9437494d6212f840837e6aa5c896a1040dc1504576d415472ac0"
    sha256 cellar: :any_skip_relocation, monterey:       "1a647f4b0703c1a85170dcaa9ac61a1c415a51008a7334a50af3f8906e548ceb"
    sha256 cellar: :any_skip_relocation, big_sur:        "8eb6b223f492943e724eed1b9ab14d08f200110a0e4580f7862d6ecd3fb65322"
    sha256 cellar: :any_skip_relocation, catalina:       "67c95158613485955a78f63e8c7963d53c4f19374268a097df6e48cb3ff43c7b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e90c319688bab0d6d0dce21acf5ee9e07ce299ddcacfc6b464d9ef1163231e10"
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
