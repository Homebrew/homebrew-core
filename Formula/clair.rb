class Clair < Formula
  desc "Vulnerability Static Analysis for Containers"
  homepage "https://github.com/quay/clair"
  url "https://github.com/quay/clair/archive/v4.5.1.tar.gz"
  sha256 "83c8b42fc2ab260de4f73a7954e4e98b51adea38ea07c1d4ce6bbb67c2900818"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "48910e500e51714018866cd9e1659bfdd25ce1f9c74573465a8b3614c2d089ba"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cac366d740ad63a7e859815a89ba5cb19901f89434c4136b16e2c6523c304219"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c5cde005fb2780d74c3f5b25b349b703e93b122bf42ba5df553ad5f41108d2a6"
    sha256 cellar: :any_skip_relocation, monterey:       "db39bcecc3b259b40b0d2596d41af8ba352eb05fb40676fb1086f07bcb932f6c"
    sha256 cellar: :any_skip_relocation, big_sur:        "8203b55a11ace787a942a4978dcd78e69e0ff12f76be7c3b77d498e903cb9918"
    sha256 cellar: :any_skip_relocation, catalina:       "a1fc2268f3a0353bd9af078bb5eaa14418e1211a4b5ff59b681b60eacb398470"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "54eb0f8ea70369b379b64bfdf4487730fa3e1c3591f4dfcc02364bdc89342e99"
  end

  depends_on "go" => :build
  depends_on "rpm"
  depends_on "xz"

  def install
    ldflags = %W[
      -s -w
      -X main.Version=#{version}
    ]

    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/clair"
    (etc/"clair").install "config.yaml.sample"
  end

  test do
    http_port = free_port
    db_port = free_port
    (testpath/"config.yaml").write <<~EOS
      ---
      introspection_addr: "localhost:#{free_port}"
      http_listen_addr: "localhost:#{http_port}"
      indexer:
        connstring: host=localhost port=#{db_port} user=clair dbname=clair sslmode=disable
      matcher:
        indexer_addr: "localhost:#{http_port}"
        connstring: host=localhost port=#{db_port} user=clair dbname=clair sslmode=disable
      notifier:
        indexer_addr: "localhost:#{http_port}"
        matcher_addr: "localhost:#{http_port}"
        connstring: host=localhost port=#{db_port} user=clair dbname=clair sslmode=disable
    EOS

    output = shell_output("#{bin}/clair -conf #{testpath}/config.yaml -mode combo 2>&1", 1)
    # requires a Postgres database
    assert_match "service initialization failed: failed to initialize indexer: failed to create ConnPool", output
  end
end
