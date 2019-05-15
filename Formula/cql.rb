class Cql < Formula
  desc "Decentralized SQL database with blockchain features"
  homepage "https://covenantsql.io"
  url "https://github.com/CovenantSQL/CovenantSQL/archive/v0.6.0.tar.gz"
  sha256 "2e14e9f44940c0cc3d861ebd7430a962e08c91b3569d85cc6be7460ebe3215aa"
  head "https://github.com/CovenantSQL/CovenantSQL.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "9160d14a8823811ca48eb4830ef5043d8ff5cff01a4d373639ee8925ffa5b4de" => :mojave
    sha256 "2b5ab50d30ee8c7211f0e5b7d03adc23c2ba5960f0114ea0b58d7248d5655b29" => :high_sierra
    sha256 "72605d4e88deb15555c67b23a665d501d7cf74d8389fde3c0403050450ad3934" => :sierra
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
