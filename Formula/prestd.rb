class Prestd < Formula
  desc "Simplify and accelerate development on any Postgres application, existing or new"
  homepage "https://github.com/prest/prest"
  url "https://github.com/prest/prest/archive/v1.1.3.tar.gz"
  sha256 "64df1a85556705161da82ee3bfe07eeff513faac4cd95d20a71f37f98777841f"
  license "MIT"
  head "https://github.com/prest/prest.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5416f9ab63c253685022d5ddd1098b7906d8571bb83a55b97b0820b78857d41b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "32b0a0ff176dad26750dc501dfd2d30dd908003944e6876dba0d1e5b1a0c3964"
    sha256 cellar: :any_skip_relocation, monterey:       "5a4dc43ab43e23c9e54356b879fb165c1c8390f1cd08f90fcb5120055ed37220"
    sha256 cellar: :any_skip_relocation, big_sur:        "4837ed8b319098d2e1754cb66d7cfc6c8286986cc4f310fcc3ba22f30c2fba50"
    sha256 cellar: :any_skip_relocation, catalina:       "ea16aaaa22b898bcc8e477226f816dc5869c495a51ce1a4c3bfbee819b4116a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "287aa5eb191a758f4447472383b333b994e90b499ce9d4d01317246d4a4278e3"
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
