class Prestd < Formula
  desc "Simplify and accelerate development on any Postgres application, existing or new"
  homepage "https://github.com/prest/prest"
  url "https://github.com/prest/prest/archive/refs/tags/v2.3.0.tar.gz"
  sha256 "7d078e7e1480c639fd3b1ed3666eadfe6a9b679b7376ea1d0d061707521f6b30"
  license "MIT"
  head "https://github.com/prest/prest.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dcc70833cae00bc6807f80c90915d1350793159d182a69212fb5e43072db06c8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "55d141ba0d6d6ef3814b1f32d9de530ff798b5e522c73fad5a18b12ed5b8d54b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "60845ed1c92ed80aac91c7dd1e617d1e32ec1ae2e48ae3a77e6e152a70300675"
    sha256 cellar: :any_skip_relocation, sonoma:        "a32d4aa0f1c9fe51334c53ae290dd8b23d6e6a7a6154e29dedb4e566054071c9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bf64f3c167caa90c72dde7727b86a86c5190c4727196aba758d43ebc461d0ab9"
    sha256 cellar: :any,                 x86_64_linux:  "74862a34a7df2047bafd6658da321a4e770577764552cd710e1ea59981264a55"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/prest/prest/v#{version.major}/helpers.PrestVersionNumber=#{version}"
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
