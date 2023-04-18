class GoFeatureFlagRelayProxy < Formula
  desc "Stand alone server to run GO Feature Flag"
  homepage "https://gofeatureflag.org"
  url "https://github.com/thomaspoignant/go-feature-flag.git",
      tag:      "v1.8.0",
      revision: "01d6ccc609ce79a8b6489bf2ba3c21da63324673"
  license "MIT"
  head "https://github.com/thomaspoignant/go-feature-flag.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f8ff317d33a9f047d0bce2aa97939e5101bdf58ef0e82092bf44a0a586d32030"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7d8e2cf1a6680ae4c2c8202e3fec0bd075aa0ab484a98584c646aecf51057830"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f8ff317d33a9f047d0bce2aa97939e5101bdf58ef0e82092bf44a0a586d32030"
    sha256 cellar: :any_skip_relocation, ventura:        "5c4566ddd8e6e9e2772aa29ba0c4fc290cb6e8375d6443b53afc713ed526b99b"
    sha256 cellar: :any_skip_relocation, monterey:       "82f72a862c1d10dddd2a09a949f30913d8abf67b5295c0ea53da3f0962b6f0ee"
    sha256 cellar: :any_skip_relocation, big_sur:        "82f72a862c1d10dddd2a09a949f30913d8abf67b5295c0ea53da3f0962b6f0ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "599f49b200cfca407badfb7949639001a1f22117c807a268a941b8253870af4e"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = %W[
      -s -w
      -X main.version=#{version}
    ]

    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/relayproxy"
  end

  test do
    port = free_port

    (testpath/"flags.yml").write <<~EOS
      test-flag:
        variations:
          true-var: true
          false-var: false
        defaultRule:
          variation: true-var
    EOS

    (testpath/"test.yml").write <<~EOS
      listen: #{port}
      pollingInterval: 1000
      retriever:
        kind: file
        path: #{testpath}/flags.yml
    EOS

    begin
      pid = fork do
        exec bin/"go-feature-flag-relay-proxy", "--config", "#{testpath}/test.yml"
      end
      sleep 3

      expected_output = /true/

      assert_match expected_output, shell_output("curl -s http://localhost:#{port}/health")
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
