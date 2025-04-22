class Pgrok < Formula
  desc "Poor man's ngrok, multi-tenant HTTP/TCP reverse tunnel solution"
  homepage "https://github.com/pgrok/pgrok"
  url "https://github.com/pgrok/pgrok/archive/refs/tags/v1.4.5.tar.gz"
  sha256 "b43c145970d8a3f02aa7f1e96d5607ea57daabd675e0d760bbc837f7113bdc43"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "72caa37de045c38a7f309e615264d7debd46d4aef4db4eecbc1bd27242363366"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "72caa37de045c38a7f309e615264d7debd46d4aef4db4eecbc1bd27242363366"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "72caa37de045c38a7f309e615264d7debd46d4aef4db4eecbc1bd27242363366"
    sha256 cellar: :any_skip_relocation, sonoma:        "20cd73267e742a16928e424e9dcbd4d2df87c454a1b82a89eaa5f7bc4f4651b8"
    sha256 cellar: :any_skip_relocation, ventura:       "20cd73267e742a16928e424e9dcbd4d2df87c454a1b82a89eaa5f7bc4f4651b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cde6109a399efd862ca12f6c59a5153ce46d40fe1533d1b3e21cc3e4a46e8eb2"
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
