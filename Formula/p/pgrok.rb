class Pgrok < Formula
  desc "Poor man's ngrok, multi-tenant HTTP/TCP reverse tunnel solution"
  homepage "https://github.com/pgrok/pgrok"
  url "https://github.com/pgrok/pgrok/archive/refs/tags/v1.4.1.tar.gz"
  sha256 "e0dd1a9ec350612df37ac5e4c90798ac6f6f8cf2003e6cbb3d736c667bba2198"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "37c6d36c1f6b0f22c3115b4be5c1d8af659b53bd845193319c7473d8653bb029"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7edafb5ce275e575f5d4a99954805c417d98b39386267b6c4c033fb7f61efcf7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3ddb52a95411ce24a9369da24259ef59b37b1d86d7b3d92b513aff1ac9f59421"
    sha256 cellar: :any_skip_relocation, sonoma:         "6aba6a48f1a592e25bde72a2d0fb9a7b07d9ffe23622ac3246e310cd025f2496"
    sha256 cellar: :any_skip_relocation, ventura:        "30ad1b464b82fa3e9d6a08b08057a72666b8f6ac52eb775a4e6bb72ae8638b9f"
    sha256 cellar: :any_skip_relocation, monterey:       "9310b35d240c739a5f0df1aa6b111e55fe08b3fa2401c6a9fc8f52f459a62e26"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "34491559e05fb7a8feb9e2d00428754ef5c2555ff954749956adf07c90301cd1"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{tap.user}
      -X main.date=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(ldflags:), "./pgrok/cli"

    etc.install "pgrok.example.yml"
  end

  test do
    ENV["XDG_CONFIG_HOME"] = testpath

    system bin/"pgrok", "init", "--remote-addr", "example.com:222",
                                "--forward-addr", "http://localhost:3000",
                                "--token", "brewtest"
    assert_match "brewtest", (testpath/"pgrok/pgrok.yml").read

    assert_match version.to_s, shell_output("#{bin}/pgrok --version")
  end
end
