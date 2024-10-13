class Prestd < Formula
  desc "Simplify and accelerate development on any Postgres application, existing or new"
  homepage "https://github.com/prest/prest"
  url "https://github.com/prest/prest/archive/refs/tags/v1.5.5.tar.gz"
  sha256 "a9a94f4c00629044bf60de214b51d4defb17b30a41b369d404043adde955673f"
  license "MIT"
  head "https://github.com/prest/prest.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "90d530ba1045c0435c4302a969748ffeac089be13f9de017e0cc1bdbd2e4921c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d9e890adab9d3c25273d2da7fa712f09e9d33f0433c41e0622f8b434be37c72d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "52064a37e3a319280c38605c65a5b6dbe8fe6b91755668e3e7924b6677749912"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "04531c9856304488cae5fcdcadf6dc7fa2d59a02ac67fc41cc2381a74afcf20d"
    sha256 cellar: :any_skip_relocation, sonoma:         "34894d39bbef0a368d84c4f7b2e8bfea3f08255c99122dd4ab777a3880ed1cb0"
    sha256 cellar: :any_skip_relocation, ventura:        "cc85d1dd808c37aada1e38c52ae10be65929ea936beb528854e22e311c023dc6"
    sha256 cellar: :any_skip_relocation, monterey:       "01487780b57de6f5ff37ccfd018a0d368dd7f284dc86529f587703d454229c28"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cfdd4ff2adfe8116f6a0719a4217e003cfcfe855fbf60fcfb6d4096f29185453"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/prest/prest/helpers.PrestVersionNumber=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/prestd"
  end

  test do
    (testpath/"prest.toml").write <<~EOS
      [jwt]
      default = false

      [pg]
      host = "127.0.0.1"
      user = "prest"
      pass = "prest"
      port = 5432
      database = "prest"
    EOS

    output = shell_output("#{bin}/prestd migrate up --path .", 255)
    assert_match "connect: connection refused", output

    assert_match version.to_s, shell_output("#{bin}/prestd version")
  end
end
