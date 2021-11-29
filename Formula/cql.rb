class Cql < Formula
  desc "Decentralized SQL database with blockchain features"
  homepage "https://covenantsql.io"
  url "https://github.com/CovenantSQL/CovenantSQL/archive/v0.8.1.tar.gz"
  sha256 "73abb65106e5045208aa4a7cda56bc7c17ba377557ae47d60dad39a63f9c88a6"
  license "Apache-2.0"
  head "https://github.com/CovenantSQL/CovenantSQL.git", branch: "develop"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6f3d16b39545a07b7811657ed8de92063b3f4fc13f96e8b092be420ff80d0ed6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a5f446cb406f5aafce83406573b0a808f718e4e8b3df3d112692b824d4912e45"
    sha256 cellar: :any_skip_relocation, monterey:       "29676dd87b84617809ee42f862ddbeabb56a52df5ddffa4acc9e8fe807e7244a"
    sha256 cellar: :any_skip_relocation, big_sur:        "ba7c4a2af433caab8ca7d413629cb7a7f16c603bbe982029b0b9cf651e58b3d5"
    sha256 cellar: :any_skip_relocation, catalina:       "aca52c8e6eb35cda498056f2047efbed677cda2632d9993f19b6b26f558dd82b"
    sha256 cellar: :any_skip_relocation, mojave:         "aabedbf76babd3b74753cd478fc431a8b4da832de192c9cab733ba92564a4b1c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "35126cd0a047a47d7f08b3dc2a2967eee1d2263ef55c8eccafe4b4bfa9047385"
  end

  depends_on "go" => :build

  # Support go 1.17, remove after next release
  patch do
    url "https://github.com/CovenantSQL/CovenantSQL/commit/c1d5d81f5c27f0d02688bba41e29b84334eb438c.patch?full_index=1"
    sha256 "ebb9216440dc7061a99ad05be3dc7634db4260585f82966104a29a7c323c903d"
  end

  def install
    ENV["CGO_ENABLED"] = "1"

    ldflags = %W[
      -s -w
      -X main.version=v#{version}
      -X github.com/CovenantSQL/CovenantSQL/conf.RoleTag=C
      -X github.com/CovenantSQL/CovenantSQL/utils/log.SimpleLog=Y
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "-tags", "sqlite_omit_load_extension", "./cmd/cql"

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
