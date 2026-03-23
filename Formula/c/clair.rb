class Clair < Formula
  desc "Vulnerability Static Analysis for Containers"
  homepage "https://github.com/quay/clair"
  url "https://github.com/quay/clair/archive/refs/tags/v4.8.0.tar.gz"
  sha256 "354cfddb1e4594fd5982fdf55096f8b0e19649bcc5024156170a409aabcf3081"
  license "Apache-2.0"
  head "https://github.com/quay/clair.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ffe483117f1b13ffd763e48a0aac9971d8abdef55e907df19e58827db27c6b6d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7f5862c80475a7b964fb8c18e038f7b209e13fc8952a8ca72e80cea7dddff7e2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7f5862c80475a7b964fb8c18e038f7b209e13fc8952a8ca72e80cea7dddff7e2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7f5862c80475a7b964fb8c18e038f7b209e13fc8952a8ca72e80cea7dddff7e2"
    sha256 cellar: :any_skip_relocation, sonoma:        "09f69fddde54e84dbe00daf2152697499f26c31736bb91666d23daafc55e6fd6"
    sha256 cellar: :any_skip_relocation, ventura:       "09f69fddde54e84dbe00daf2152697499f26c31736bb91666d23daafc55e6fd6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "58d1cd30b14ef94926e917fc0ce7bff127d5542f9fde081377c347f5639cd185"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c3bd46a3c89a414ca9d775b54ebfc1e1fd15c72be92fe5897ef1218fe151a42f"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/clair"
    (etc/"clair").install "config.yaml.sample"
  end

  test do
    http_port = free_port
    db_port = free_port
    (testpath/"config.yaml").write <<~YAML
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
    YAML

    output = shell_output("#{bin}/clair -conf #{testpath}/config.yaml -mode combo 2>&1", 1)
    # requires a Postgres database
    assert_match "service initialization failed: failed to initialize indexer: failed to create ConnPool", output
  end
end
