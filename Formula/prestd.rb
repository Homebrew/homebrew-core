class Prestd < Formula
  desc "Simplify and accelerate development on any Postgres application, existing or new"
  homepage "https://github.com/prest/prest"
  url "https://github.com/prest/prest/archive/v1.1.1.tar.gz"
  sha256 "2f8fa9c8bfc4a731f5bb00fdf247502ceece90086d4476dd66c196d17e90cfdf"
  license "MIT"
  head "https://github.com/prest/prest.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2554eb9ada950cf359a2b18f930d73098a7882484ccbec073b303811afb037f0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "354ab0ab81775642252f29f6004994c04cfabeab1db32f72e8bac60f799e3bc1"
    sha256 cellar: :any_skip_relocation, monterey:       "399f15ed1b75c9f1ed1525f9ab1be42390ab0bb122c6d1fa02f7c43178e53830"
    sha256 cellar: :any_skip_relocation, big_sur:        "b73e774b52d2d75f52e54aed1bda14c7406a9a8d650d56edce2786dd37cf5d37"
    sha256 cellar: :any_skip_relocation, catalina:       "ca71bdd02e018564b0a373dba07d0cc8247fe136f01d19627f2561ba28680de7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "43a7417f383cbe43278ac1abe1a888ee2c576cc4af27492554d8db905d1cb061"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "-ldflags",
      "-s -w -X github.com/prest/prest/helpers.PrestVersionNumber=#{version}",
      "./cmd/prestd"
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

    output = shell_output("prestd migrate up --path .", 255)
    assert_match "connect: connection refused", output

    assert_match version.to_s, shell_output("prestd version")
  end
end
