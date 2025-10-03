class Prestd < Formula
  desc "Simplify and accelerate development on any Postgres application, existing or new"
  homepage "https://github.com/prest/prest"
  url "https://github.com/prest/prest/archive/refs/tags/v1.5.5.tar.gz"
  sha256 "a9a94f4c00629044bf60de214b51d4defb17b30a41b369d404043adde955673f"
  license "MIT"
  head "https://github.com/prest/prest.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6bf355f7cd67bdee9b319c0ac5b6399cae1931a634f472f9c530c4d721ae7a9b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eea2264c1eb95f71a00ea3f6dab68693bb5b1b9298e2f6761afd1ba3bd257e83"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9f98b664aed92e07ef3e312d71f344aad084b42566fdf0462a35cdaa30acaf4b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "21c93a08c0034b94acb228e73af97e4e86f3d659b6ddd77c4ce8695208150dc4"
    sha256 cellar: :any_skip_relocation, sonoma:        "6a8079afe0412aee14b9fe226f92b6a8170c7e982110439b34dbfa0f91da9b49"
    sha256 cellar: :any_skip_relocation, ventura:       "9f772bf14cb42300aa8bd426651df3f628898bbd50418260fc3dec288af47f6b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6154aa99c1ee993ecb5f5c38a1e22b84554bf0d3c6ac7cb387fc789f85c7e0fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "53b738570b9680eab675d95dcb91a8498b7c14a98beff05602330f52034889f3"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/prest/prest/helpers.PrestVersionNumber=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/prestd"

    generate_completions_from_executable(bin/"prestd", "completion")
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

    output = shell_output("#{bin}/prestd migrate up --path .", 255)
    assert_match "connect: connection refused", output

    assert_match version.to_s, shell_output("#{bin}/prestd version")
  end
end
