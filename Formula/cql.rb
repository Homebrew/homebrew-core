class Cql < Formula
  desc "Decentralized SQL database with blockchain features"
  homepage "https://covenantsql.io"
  url "https://github.com/CovenantSQL/CovenantSQL/archive/v0.6.0.tar.gz"
  sha256 "2e14e9f44940c0cc3d861ebd7430a962e08c91b3569d85cc6be7460ebe3215aa"
  head "https://github.com/CovenantSQL/CovenantSQL.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "7d2e72c5336cce4e8d6e46c084f2111fc35567dc26ab6cbfc4f5a25a570f73ef" => :mojave
    sha256 "83aaf67025bcfb0715233bfaa8c4306129d7a025b08d18a465afb47ad630abed" => :high_sierra
    sha256 "01bfd33b8f17397f446eda57e1a652595c4e63099023c4e7b638ed1f51cd1d88" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["CQLVERSION"] = "v0.6.0"
    ENV["CGO_ENABLED"] = "1"
    mkdir_p "src/github.com/CovenantSQL"
    ldflags = "-X main.version=v0.6.0 " \
      "-X github.com/CovenantSQL/CovenantSQL/conf.RoleTag=C " \
      "-X github.com/CovenantSQL/CovenantSQL/utils/log.SimpleLog=Y"
    ln_s buildpath, "src/github.com/CovenantSQL/CovenantSQL"
    system "go", "build", "-tags", "sqlite_omit_load_extension",
      "-ldflags", ldflags, "-o", "bin/cql", "github.com/CovenantSQL/CovenantSQL/cmd/cql"
    bin.install "bin/cql"
  end

  test do
    testconf = testpath/"confgen"
    system bin/"cql", "generate", testconf, "config"
    assert_predicate testconf/"private.key", :exist?
    assert_predicate testconf/"config.yaml", :exist?
  end
end
