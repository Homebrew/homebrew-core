class Prestd < Formula
  desc "Simplify and accelerate development on any Postgres application, existing or new"
  homepage "https://github.com/prest/prest"
  url "https://github.com/prest/prest/archive/v1.0.12.tar.gz"
  sha256 "faffa19741dc8c23930043a46e646f86722e969eff8535fe3cc3c469a0d5489f"
  license "MIT"
  head "https://github.com/prest/prest.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0c8018e18630bd5672aa002bf1ed49849cbea5081304af595a3e5c9a5ce5bfe2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bced5ec4c410d35ba2538cff15e2476d87bae3469ed604546bad19377edf69d8"
    sha256 cellar: :any_skip_relocation, monterey:       "b57bfcd36f46b4a9d82fc9e09c3d9b0801e39adc643c678759c4a27750aa1777"
    sha256 cellar: :any_skip_relocation, big_sur:        "4716d4eaf268a29c70073d8a09de92355cb4279d2197c21f6640d9b7aca5c16a"
    sha256 cellar: :any_skip_relocation, catalina:       "d68fda822efd7d4085c76e0111292974d62306bd693927e12767d6ea1f0b21c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6f292d11925e20fe33cfa1cda4988c707b44ff48caa8db4373a45576a6e6f3a4"
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
