class OryHydra < Formula
  desc "OpenID Certified OAuth 2.0 Server and OpenID Connect Provider"
  homepage "https://www.ory.sh/hydra/"
  url "https://github.com/ory/hydra/archive/v1.10.5.tar.gz"
  sha256 "0d53fae9e0d2a93dfa285fe473a1d44f9663247739f9a0338c6c7c8e115a1a0a"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "77854c18f822f5542273f516e349dd6d0e348e099e72b958eb9fdbbddafdc05d"
    sha256 cellar: :any_skip_relocation, big_sur:       "9a76c22d363440fe2b8cb6907507fe7ab944961689f8cca84b59668b6911a3f5"
    sha256 cellar: :any_skip_relocation, catalina:      "bbc3f75a8bb71cc6f9877098ab6d2dffb68c7edb87e7e2cb2d2221d8359aa482"
    sha256 cellar: :any_skip_relocation, mojave:        "7d281cb2973926ffe5eaacc652622a9dc888a8461fad2fbf14d49538b923faf0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c8d71f7a3455a2eb1848439df7beb1acaec7169f6ad461c229b1909e4f3c8a4e"
  end

  depends_on "go" => :build

  conflicts_with "hydra", because: "both install `hydra` binaries"

  # Support go 1.17, remove after next release
  patch do
    url "https://github.com/ory/hydra/commit/57b41e93f89ff847da0386a8315603bba203f417.patch?full_index=1"
    sha256 "9b51bb86935b53e30e7e1dc3585b94f4fd901e1127263b783110d7b1bb983e11"
  end

  def install
    ENV["GOBIN"] = bin
    system "make", "install"
  end

  test do
    admin_port = free_port
    (testpath/"config.yaml").write <<~EOS
      dsn: memory
      serve:
        public:
          port: #{free_port}
        admin:
          port: #{admin_port}
    EOS

    fork { exec bin/"hydra", "serve", "all", "--config", "#{testpath}/config.yaml" }
    sleep 20

    endpoint = "https://127.0.0.1:#{admin_port}/"
    output = shell_output("#{bin}/hydra clients list --endpoint #{endpoint} --skip-tls-verify")
    assert_match "| CLIENT ID |", output
  end
end
