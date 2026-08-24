class Prestd < Formula
  desc "Simplify and accelerate development on any Postgres application, existing or new"
  homepage "https://github.com/prest/prest"
  url "https://github.com/prest/prest/archive/refs/tags/v2.4.2.tar.gz"
  sha256 "08909fd777db13403f7c89bed65a88f540fd7b810f3c7140490c6d5bb34072bb"
  license "MIT"
  head "https://github.com/prest/prest.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a295e4693979160b07e21d42f0682b103882c67142ff1ca26c2fb77fd1d5213e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1ad58452d40317e6f41285a7228010ea299a10a9015d6e60f8409e2b3393f829"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f7e0ce8def38f0592dd4b2f9906553351b5c0b3e72b811f461819214b58f5489"
    sha256 cellar: :any_skip_relocation, sonoma:        "663858957b1a4fd738195027424f96cc25c95dc3d53846ee0cdc1066e83305f3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c0a58468f482182314c7aab7b1cc465358f70c488f077077defbc92fe898f47f"
    sha256 cellar: :any,                 x86_64_linux:  "34f6f07c7bf14a448476292199ec70fafcb9299406ffd07b83988408e3ff3bcd"
  end

  depends_on "go" => :build

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
