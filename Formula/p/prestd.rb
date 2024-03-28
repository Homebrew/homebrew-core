class Prestd < Formula
  desc "Simplify and accelerate development on any Postgres application, existing or new"
  homepage "https://github.com/prest/prest"
  url "https://github.com/prest/prest/archive/refs/tags/v1.4.3.tar.gz"
  sha256 "2173f065ac289821781f489f934670e0be400af69a1c118bff067e583e341fbd"
  license "MIT"
  head "https://github.com/prest/prest.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2c29c94c52a115f0771b902d95ff6e45ad0d932072a2d051c39b40bc6f60a3fe"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a855d7312dd8e13a6b77133b67a642127effe1c9f78a106001f50c65625a498b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f1effcc991bddfd4901da17e32bbe067c6b89dffbd8a6065445bcf3fd80c3a65"
    sha256 cellar: :any_skip_relocation, sonoma:         "d83bbff3992bd6feb9f6a7a6b03ce32e4093806c4a5b10961c7556d77fa31a2d"
    sha256 cellar: :any_skip_relocation, ventura:        "591f003826e822e7588535f165b889ac1b1b747d1cf4d5b831927752b1fbd1ca"
    sha256 cellar: :any_skip_relocation, monterey:       "c23bdef864ff6104884a9bf22b314839773475a3c04e080ecc74c0229dc5697f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "47b0a05e0b0fb5bac6c1ab6972c50f0a3cf58d2f597e688685da519065ade5b5"
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
