class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/v0.26.9.tar.gz"
  sha256 "ed88d6b700334ac8df72b1b2f70eef8e2233982ac15a38a9f1eb41313679bb4a"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "269ae3704d663db5641b642ab1a3c4325c0bd9b329809e9e5d492b5a22373f0d"
    sha256 cellar: :any_skip_relocation, big_sur:       "062841934972ea82aedb8cd7919cbfc541d91c7986de2eb9fe3a687949cd4dba"
    sha256 cellar: :any_skip_relocation, catalina:      "94c658c05a5e54f458215b15265868a1fe37132a6d192bfc6f7180f9900fc644"
    sha256 cellar: :any_skip_relocation, mojave:        "b32cb3a1243ee75cdb72211e3c1bf645db7e9ceb755fd9a55f6ec8b65b6db3d9"
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
