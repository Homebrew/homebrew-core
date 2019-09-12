class Cql < Formula
  desc "Decentralized SQL database with blockchain features"
  homepage "https://covenantsql.io"
  url "https://github.com/CovenantSQL/CovenantSQL/archive/v0.8.0.tar.gz"
  sha256 "fc63d9bc296b037c8a8fd1984bc6e4156d0c73d9948dfa8654a954f904ad1f4a"
  head "https://github.com/CovenantSQL/CovenantSQL.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "49533c8489134ec2059062f52cdcbcc09eec2b51c0732bfd7920a16c99eeabf5" => :mojave
    sha256 "fc13d8162b67116b9542e055a6ae6772a2c48a000c594baf2a799a74b4ca5edc" => :high_sierra
    sha256 "fa82fc3f35356e8ea6278117c185e0cba469d80fbaca38d25f5adfdc96e4c910" => :sierra
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
