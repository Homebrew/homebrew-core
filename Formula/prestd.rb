class Prestd < Formula
  desc "Simplify and accelerate development on any Postgres application, existing or new"
  homepage "https://github.com/prest/prest"
  url "https://github.com/prest/prest/archive/v1.2.2.tar.gz"
  sha256 "203f764f945c10bb2cc18e115fa17f799f8d7ca9291fb64ed720df94bd52c1a0"
  license "MIT"
  head "https://github.com/prest/prest.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fa63745029f68c9ed407beb06f1a3c6f1f16cf8b00cf2b6e1d998587bdb55670"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f608e465a7ad71d459ab899d65aeac077832db09134cf956bc9f94d7e81cd75d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e881a69f652036e1275361f3e3fbe89b5f36a370af948ebfd0a09fa638ea726b"
    sha256 cellar: :any_skip_relocation, ventura:        "d513f1ec3078e85ef335d7f9af09088adb292d0a196460c69f4f36d6b4d00bcd"
    sha256 cellar: :any_skip_relocation, monterey:       "1eec6ca97946b7de2452ab29b8d124af2253fbfc48d83fb61e08dc202a0156bf"
    sha256 cellar: :any_skip_relocation, big_sur:        "c3d82b941cc1e59e82564f625a29396ab7885011913fd4f38a67bfd9a6b16d9e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ab858855157c36cd1faa04eb83a7762c23cc41cc86954be501ee21bc8c6be3ec"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/prest/prest/helpers.PrestVersionNumber=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/prestd"
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
