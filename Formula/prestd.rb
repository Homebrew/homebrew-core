class Prestd < Formula
  desc "Simplify and accelerate development on any Postgres application, existing or new"
  homepage "https://github.com/prest/prest"
  url "https://github.com/prest/prest/archive/v1.2.4.tar.gz"
  sha256 "5d62a864d65c9ba2f00364cf86d78136bd2bf2f753579b121d3f662308aa286a"
  license "MIT"
  head "https://github.com/prest/prest.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2140dcf7060212033f0f77139888ffb3480256ac845b7831e6534e115a5f885f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ea5fccce4ddeb5c1256d3fcc57ecde8584e0ebcc5bc9c21c2ee0bca2a4c0cf94"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c4e22be7ad68b3e1e647b1ac137d76280ca9a206cb768bf17c2059ea973b7222"
    sha256 cellar: :any_skip_relocation, ventura:        "9bb16ea1b14e36e4bc86d722c6ecfe38432dca8169b6c965fbe589486ae41b84"
    sha256 cellar: :any_skip_relocation, monterey:       "2ac64799ba7b86bd9769e24c8845bc1ece7d2b90b855669e6133b19286fb2d9e"
    sha256 cellar: :any_skip_relocation, big_sur:        "c5dfa16aaa85e3c32f243796dc8c752c0ea4daa1feca5f3520dad92b36a13509"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c29ea4e5123ea0b6a240a97e9f6bb36a7d49ce13bb6f652f909b7f9d878d23fa"
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
