class Pgrok < Formula
  desc "Poor man's ngrok, multi-tenant HTTP/TCP reverse tunnel solution"
  homepage "https://github.com/pgrok/pgrok"
  url "https://github.com/pgrok/pgrok/archive/refs/tags/v1.3.4.tar.gz"
  sha256 "2da14eeae3d9678bffd27ca5cf3900bf2c041628cbccae939137d73f0522d747"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "66564038a342b958d0e2cc33f782143adc32bf66e6f477e557bb44f3e74247fd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "66564038a342b958d0e2cc33f782143adc32bf66e6f477e557bb44f3e74247fd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "66564038a342b958d0e2cc33f782143adc32bf66e6f477e557bb44f3e74247fd"
    sha256 cellar: :any_skip_relocation, ventura:        "25451b9a83eead335118ccae92df6d61756ae4bae062adbe32761b32b63d8c01"
    sha256 cellar: :any_skip_relocation, monterey:       "25451b9a83eead335118ccae92df6d61756ae4bae062adbe32761b32b63d8c01"
    sha256 cellar: :any_skip_relocation, big_sur:        "25451b9a83eead335118ccae92df6d61756ae4bae062adbe32761b32b63d8c01"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dcad13368725d8de10094f7dc9ac73231447095d2aa6e0412ef11bd1b8f30677"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{tap.user}
      -X main.date=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/pgrok"

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
