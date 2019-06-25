class Cql < Formula
  desc "Decentralized SQL database with blockchain features"
  homepage "https://covenantsql.io"
  url "https://github.com/CovenantSQL/CovenantSQL/archive/v0.7.0.tar.gz"
  sha256 "552832e7ff8586170e47d1c3aa6f526e366c6b804bb3fa37a08f87f112bcfb7c"
  revision 1
  head "https://github.com/CovenantSQL/CovenantSQL.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f629558de28e0fee43be602f0fd8984adc083198d813a94dc8dd87c91f2015e1" => :mojave
    sha256 "1c3f6ed32148cb851663e7799610f85b6f94ae31b3703258fd971cc7dcdd63d5" => :high_sierra
    sha256 "5dea26e91da9ce55e0adb1397eb695d47b6e0d678e5afab435a58381836a1aad" => :sierra
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
