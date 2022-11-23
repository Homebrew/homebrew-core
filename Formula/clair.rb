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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3385e3ea407d0e37896de6a9c4162621d2a7c786c8feed6387511eab462fe7f6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fe0318b20f8257649db32233d68476358acb4bda3149bf128fbf1b7aa4f28452"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fe6f6ab7ee6984c44c8631339dd881c0486cf0e032fb5b524c254726d691c2df"
    sha256 cellar: :any_skip_relocation, monterey:       "dc4e83d6284e510aadc27e87fb6a6f9ac5d260a26a3d3c27946f627e26ff53bb"
    sha256 cellar: :any_skip_relocation, big_sur:        "eee1ad5f4103bd3a0b4707b451a00e9eeba3e30066d514ed1646abcac74f7450"
    sha256 cellar: :any_skip_relocation, catalina:       "edcc194f963aa58dbd2d0b77cda92ed351b593cfb85cfb36fbae0df346e27ee6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "222688479b8b7af6794526b1ba69bfbb61bc6ed0b7e927e0d0c1e9e709b0ddd9"
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
