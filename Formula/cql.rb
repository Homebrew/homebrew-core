class Cql < Formula
  desc "Decentralized SQL database with blockchain features"
  homepage "https://covenantsql.io"
  url "https://github.com/CovenantSQL/CovenantSQL/archive/v0.8.0.tar.gz"
  sha256 "fc63d9bc296b037c8a8fd1984bc6e4156d0c73d9948dfa8654a954f904ad1f4a"
  head "https://github.com/CovenantSQL/CovenantSQL.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ee386d3bf77d29254e8d48a152f71a37bad70784c2a0cc08a2b8bb67b751acef" => :mojave
    sha256 "524cbeeb80f87cb5696499be3bb6acc8e441f219ac2faf579ef5171351d07c9e" => :high_sierra
    sha256 "c6dd8729b303196f045265da497765099cb5900a3ce2edbbaf93c16a6f401a55" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["CQLVERSION"] = "v#{version}"
    ENV["CGO_ENABLED"] = "1"
    mkdir_p "src/github.com/CovenantSQL"
    ldflags = "-X main.version=v#{version} " \
      "-X github.com/CovenantSQL/CovenantSQL/conf.RoleTag=C " \
      "-X github.com/CovenantSQL/CovenantSQL/utils/log.SimpleLog=Y"
    ln_s buildpath, "src/github.com/CovenantSQL/CovenantSQL"
    system "go", "build", "-tags", "sqlite_omit_load_extension",
      "-ldflags", ldflags, "-o", "bin/cql", "github.com/CovenantSQL/CovenantSQL/cmd/cql"
    bin.install "bin/cql"
    bash_completion.install "bin/completion/cql-completion.bash"
    zsh_completion.install "bin/completion/_cql"
  end

  test do
    testconf = testpath/"confgen"
    system bin/"cql", "generate", testconf
    assert_predicate testconf/"private.key", :exist?
    assert_predicate testconf/"config.yaml", :exist?
  end
end
