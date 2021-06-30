class Cql < Formula
  desc "Decentralized SQL database with blockchain features"
  homepage "https://covenantsql.io"
  url "https://github.com/CovenantSQL/CovenantSQL/archive/v0.8.1.tar.gz"
  sha256 "73abb65106e5045208aa4a7cda56bc7c17ba377557ae47d60dad39a63f9c88a6"
  license "Apache-2.0"
  head "https://github.com/CovenantSQL/CovenantSQL.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "74a8c72f8d73c53ca3dbfcc443cf4319a9c5b590de766acb53f618063454bafa"
    sha256 cellar: :any_skip_relocation, big_sur:       "cf8e7615d8f5c837efd97b0d5dfc1c0376522fa8823b3d12242470084e82fd81"
    sha256 cellar: :any_skip_relocation, catalina:      "56b5f1a6ac0916da4bf79ae54ce6be4d5d7fae8d943cc3bab400e66e79cd0aec"
    sha256 cellar: :any_skip_relocation, mojave:        "100623450a27784a84597f68cc03956ec715a7121cdffbe33d51126bb681392c"
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
