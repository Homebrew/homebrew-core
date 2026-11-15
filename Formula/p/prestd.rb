class Prestd < Formula
  desc "Simplify and accelerate development on any Postgres application, existing or new"
  homepage "https://github.com/prest/prest"
  url "https://github.com/prest/prest/archive/refs/tags/v2.5.3.tar.gz"
  sha256 "334f54fb710bf6f291ccde84a1d2083784e023ac9c876fa88dad91debd26a1e9"
  license "MIT"
  head "https://github.com/prest/prest.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "212ada5a3c86d788bbf2af125bba917fac7b1d02cedff5000da32f774d6e0711"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7745e9a9597a1fa55d189c5070686be5dcd7b3ceca6457e63826bb616f0c4ccb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5a7ea7e8bdf90cb4944f3a9a565ded868fb9e6d6c767889059b3eaa512fe19c1"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "5e31b4f720f3b59b07739f361abd78c79a8d6f1d197510dbf6035e4a87b0112f"
    sha256 cellar: :any,                 x86_64_linux:      "7c6cdcc67bd77ede000a08bafc3ad8b0c404c716961f740fdc80b762e8e92f97"
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
