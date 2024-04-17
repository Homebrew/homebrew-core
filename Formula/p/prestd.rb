class Prestd < Formula
  desc "Simplify and accelerate development on any Postgres application, existing or new"
  homepage "https://github.com/prest/prest"
  url "https://github.com/prest/prest/archive/refs/tags/v1.5.0.tar.gz"
  sha256 "999c05ebb747dc81e83ebcbe339cea744e592111fc8cc55b035d0d8bd0caa483"
  license "MIT"
  head "https://github.com/prest/prest.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a4a5bca97b32701e40cdbfaf7ff84407b592c38c4b60a6860e034704f97bdcb7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "84709de306c27e76218a98f00798f0b72f1e57ec19e28e72372eb04d629febba"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2985d513a7f841d49231ec0a623e2f3df24036cacbd356f6790942baf1df4065"
    sha256 cellar: :any_skip_relocation, sonoma:         "9ea83fc81324974bb7f3167ab7b1ccac58da2a2f39fe28d97f9ff3d98e4ffb84"
    sha256 cellar: :any_skip_relocation, ventura:        "5e056caa634866f8ed649d3010b3a63d6b38d2f8a8d45991cee5344564530080"
    sha256 cellar: :any_skip_relocation, monterey:       "44c77fa6dcb5a8fbc90ecd96ae7146bf96b049bcdd33f90ee912fcaedff074d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7ef22fca53b9754f7a1d2a39aa4f6f55115ee22ff01e2d74cc6ea1f98566cb65"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/prest/prest/helpers.PrestVersionNumber=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/prestd"
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
