class Cql < Formula
  desc "Decentralized SQL database with blockchain features"
  homepage "https://covenantsql.io"
  url "https://github.com/CovenantSQL/CovenantSQL/archive/v0.8.0.tar.gz"
  sha256 "fc63d9bc296b037c8a8fd1984bc6e4156d0c73d9948dfa8654a954f904ad1f4a"
  license "Apache-2.0"
  head "https://github.com/CovenantSQL/CovenantSQL.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "f8c84bc3df9fd6eb3252f38ef53af69f2b8e4d6ee4af6c40ddbd1ddb642cf9f3" => :big_sur
    sha256 "6910f358939ba05d8db050688abe4d6df42ce12801949e8be7f49743023d572f" => :catalina
    sha256 "dd644eb78e0c68e04fcde376481d12ab7d5a0cfddcd844fe3529d8129fec262b" => :mojave
    sha256 "623599aba9f2a656f5ee530dd367b0741b6b1e7a3e564c629adf29b5ef3a290e" => :high_sierra
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
