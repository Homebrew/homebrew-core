class Pgrok < Formula
  desc "Poor man's ngrok, multi-tenant HTTP/TCP reverse tunnel solution"
  homepage "https://github.com/pgrok/pgrok"
  url "https://github.com/pgrok/pgrok/archive/refs/tags/v1.4.0.tar.gz"
  sha256 "c1e9b3b506b39c5a1e6d9d31e78ba28c1c62ff698ceab8ba5f30881bfd8af6ad"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8165af1dc7d72e1c72eb642feb20e1da01911a8e5c027d5af113207e9144ae2e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f43696d9e60b6dff2bb3f93309fa67e5618143035759a92b02dc80875cb918e7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ef5d9be8ee4f399660c507eca7647606b3d6b2bb2f3bbe54c9167deda458792d"
    sha256 cellar: :any_skip_relocation, ventura:        "a0df041caadeec0edd908855e60e69ddeba089a85b8167eb235b230098c9c30f"
    sha256 cellar: :any_skip_relocation, monterey:       "2b2ef4dd3b91082a88bb0d9dd86479ce26b846c5e60647f2a1ef7ba40b179f79"
    sha256 cellar: :any_skip_relocation, big_sur:        "1c31fb7b354524f3801b871d7b737b2d7adf1cbf6b1abd1e1551b02c0b713fb5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0fb845940a156201b9071a241b9bc193c4753e654065e8e96a40aeccfc688cc7"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{tap.user}
      -X main.date=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(ldflags: ldflags), "./pgrok/cli"

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
