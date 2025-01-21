class Pgrok < Formula
  desc "Poor man's ngrok, multi-tenant HTTP/TCP reverse tunnel solution"
  homepage "https://github.com/pgrok/pgrok"
  url "https://github.com/pgrok/pgrok/archive/refs/tags/v1.4.4.tar.gz"
  sha256 "163fa1148de55580d68a0a13244c9e383d5648f81879fca375e43aaad870c23b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a122b633d1350ed2eb7dd40de635f87011d5d7b41594455d5fcb0e7443d95d0d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a122b633d1350ed2eb7dd40de635f87011d5d7b41594455d5fcb0e7443d95d0d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a122b633d1350ed2eb7dd40de635f87011d5d7b41594455d5fcb0e7443d95d0d"
    sha256 cellar: :any_skip_relocation, sonoma:        "2f24566142b5e82f2dbc62f0e2509babc878c556a6a16f1ad6ddac6d9e699938"
    sha256 cellar: :any_skip_relocation, ventura:       "2f24566142b5e82f2dbc62f0e2509babc878c556a6a16f1ad6ddac6d9e699938"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d3fcff195ca1c7a6499f4a0ae6b5fbb3b37af3e94c30faef86b8c0a7f556b4b6"
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
