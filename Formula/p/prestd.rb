class Prestd < Formula
  desc "Simplify and accelerate development on any Postgres application, existing or new"
  homepage "https://github.com/prest/prest"
  url "https://github.com/prest/prest/archive/refs/tags/v2.5.2.tar.gz"
  sha256 "6bcc88a8e97524732838599d80ccc33a93ee6d4c9beb568904a318dfd130ab51"
  license "MIT"
  head "https://github.com/prest/prest.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7b4d57cb462f049cd5d83b9c3bf94d887fc53cc01c2c2937380ee5fc25668a2a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "6a10a8788b74888a52c8bba2732344ed400cca4f7a2971cca318f4a2cea148c4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "17b74397d920b16899029d073806f898674a6676284297db4c0563976b61f211"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "3f1576e947f2697574dc8f0849d5e55669f6336c80c02ab3a3031a7bf95430c9"
    sha256 cellar: :any,                 x86_64_linux:      "746d1e98705c273b39ba6674250ff63026368a4bb62c025ac4822c6a35c7bdb0"
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
