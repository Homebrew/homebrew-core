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
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "acc8c8862ea6867aa11b5a5e9431c978c6252bc9c267b455cb004be3c4589efa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "49bb751ee32ae1ba13d0e1b87b801b4b3f80d74adfdabc44467068c0abcd1a12"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e1d02886e9ac10386dc793878548d3429bd99405212f10a27d25d63519702192"
    sha256 cellar: :any_skip_relocation, sonoma:        "adaa7ed259ca16397bdc67c323eb8969aa02b6541275b892f98efae4ae49bb36"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "067511ae084f7eeb570344d47d52ed78ff71b5a679c92bd8dfb63d411ccb7307"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4ac75a592d6bd7599df97d1ee3cd17d52c5d6c3ab8e37834a03a45abac8f81b2"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/prest/prest/helpers.PrestVersionNumber=#{version}"
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

    output = shell_output("#{bin}/prestd migrate up --path .", 255)
    assert_match "connect: connection refused", output

    assert_match version.to_s, shell_output("#{bin}/prestd version")
  end
end
