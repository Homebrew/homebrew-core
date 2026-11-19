class Prestd < Formula
  desc "Simplify and accelerate development on any Postgres application, existing or new"
  homepage "https://github.com/prest/prest"
  url "https://github.com/prest/prest/archive/refs/tags/v2.6.0.tar.gz"
  sha256 "d12e3c151b90cde9b3d8d940f1909026d69e1f3ada55b5df8265403fae774e1e"
  license "MIT"
  head "https://github.com/prest/prest.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "bcb435bbfbea25bb218df3e4b83cf69dc588b04e580cfc2558a62a39b1689b62"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "581d5923c0ffa1194261e12c992e8a48e5828445143d059a46c33b52c5e7ea06"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9f89ee2c19e24d6250dd27e8d8cbb1f6adfcb3ed046235d0e6deb2ee77b9c71f"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "40931911ad9669608579cab7b2cc68d74daf353e3b5cbe1592cd6ae6e74c608a"
    sha256 cellar: :any,                 x86_64_linux:      "d3a1aa857cc00a49ed41d2e8a554a684e94b5645e74a5d213f8eb2c8b3ee68bb"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-X github.com/prest/prest/v#{version.major}/helpers.PrestVersionNumber=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/prestd"

    generate_completions_from_executable(bin/"prestd", shell_parameter_format: :cobra)
  end

  test do
    (testpath/"prest.toml").write <<~TOML
      [jwt]
      default = false

      [pg]
      host = "127.0.0.1"
      user = "prest"
      pass = "prest"
      port = 5432
      database = "prest"
    TOML

    output = shell_output("#{bin}/prestd migrate up --path .", 1)
    assert_match "connect: connection refused", output

    assert_match version.to_s, shell_output("#{bin}/prestd version")
  end
end
