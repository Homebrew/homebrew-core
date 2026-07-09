class GoFeatureFlagRelayProxy < Formula
  desc "Stand alone server to run GO Feature Flag"
  homepage "https://gofeatureflag.org"
  url "https://github.com/thomaspoignant/go-feature-flag/archive/refs/tags/v1.55.0.tar.gz"
  sha256 "1932048138ae0ae21e56f48880789def5e3573101afab92654912b5bc7e20f8f"
  license "MIT"
  head "https://github.com/thomaspoignant/go-feature-flag.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "52cd373c39fbaafd54bdaf924cac5564814fb83e5d250136025bf90152dd37c9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7db51123cef99b4c1c2c4ebd3f1ff910227bc90bf19260016fca21a23b0b9f3d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a53fe2283db03727da365ee4931e6e407805c19a5dccb2ecc4ada1a9c29ea7b6"
    sha256 cellar: :any_skip_relocation, sonoma:        "9a01ee4a0d5bee4b5ee2a734500cbe37bf4b3f128c44359e4a47434a274c2d05"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b8ddc53b1b778154664b36e52c563c5e147105da5a961ba551d5c5125f3500ba"
    sha256 cellar: :any,                 x86_64_linux:  "4efd17e92a42f629bc0ca83f956bcee464c76a0bb8026ca01c7be1520b287550"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/relayproxy"
  end

  test do
    port = free_port

    (testpath/"flags.yml").write <<~YAML
      test-flag:
        variations:
          true-var: true
          false-var: false
        defaultRule:
          variation: true-var
    YAML

    (testpath/"test.yml").write <<~YAML
      listen: #{port}
      pollingInterval: 1000
      retriever:
        kind: file
        path: #{testpath}/flags.yml
    YAML

    pid = spawn bin/"go-feature-flag-relay-proxy", "--config", testpath/"test.yml"
    begin
      assert_match "true", shell_output("curl --silent --retry 5 --retry-connrefused http://localhost:#{port}/health")
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
