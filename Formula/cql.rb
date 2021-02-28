class Cql < Formula
  desc "Decentralized SQL database with blockchain features"
  homepage "https://covenantsql.io"
  url "https://github.com/CovenantSQL/CovenantSQL/archive/v0.8.1.tar.gz"
  sha256 "73abb65106e5045208aa4a7cda56bc7c17ba377557ae47d60dad39a63f9c88a6"
  license "Apache-2.0"
  head "https://github.com/CovenantSQL/CovenantSQL.git"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "b6446d50149ecd5016e5a2e22f1a912a75743b98e36f032236f2c9bab8a52b67"
    sha256 cellar: :any_skip_relocation, big_sur:       "f8c84bc3df9fd6eb3252f38ef53af69f2b8e4d6ee4af6c40ddbd1ddb642cf9f3"
    sha256 cellar: :any_skip_relocation, catalina:      "6910f358939ba05d8db050688abe4d6df42ce12801949e8be7f49743023d572f"
    sha256 cellar: :any_skip_relocation, mojave:        "dd644eb78e0c68e04fcde376481d12ab7d5a0cfddcd844fe3529d8129fec262b"
    sha256 cellar: :any_skip_relocation, high_sierra:   "623599aba9f2a656f5ee530dd367b0741b6b1e7a3e564c629adf29b5ef3a290e"
  end

  depends_on "go" => :build

  def install
    ENV["CQLVERSION"] = "v#{version}"
    ENV["CGO_ENABLED"] = "1"

    ldflags = "-s -w -X main.version=v#{version} " \
      "-X github.com/CovenantSQL/CovenantSQL/conf.RoleTag=C " \
      "-X github.com/CovenantSQL/CovenantSQL/utils/log.SimpleLog=Y"
    system "go", "build", *std_go_args, "-tags", "sqlite_omit_load_extension",
      "-ldflags", ldflags, "./cmd/cql"

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
