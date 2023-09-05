class GoFeatureFlagRelayProxy < Formula
  desc "Stand alone server to run GO Feature Flag"
  homepage "https://gofeatureflag.org"
  url "https://github.com/thomaspoignant/go-feature-flag/archive/refs/tags/v1.15.1.tar.gz"
  sha256 "1aada56d7a43c1dc61df5bbd9f7f5d7e1d94b4eac324563572855887909a5d68"
  license "MIT"
  head "https://github.com/thomaspoignant/go-feature-flag.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3f30998493399bb11ca6357a79727bba47054612b6ab02d4c04b997b07be2d76"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "da9631b8d8246cdc4449295c93d4c1accf22de77464138b700c22d75d6d54ff2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a7a5b4a32edf780b40f083873b35010f143cf0214df7264540224e36f8f335d4"
    sha256 cellar: :any_skip_relocation, ventura:        "75357aa2a2b1ef92afe4d2b431cd2bfe128cec5616deb5fa706a924e2ee36bd9"
    sha256 cellar: :any_skip_relocation, monterey:       "dc1579790c9f81f890e3ccdd9d2c7ede68310639596251bed6e72a91a074581f"
    sha256 cellar: :any_skip_relocation, big_sur:        "bbf1919b5f58b6170ecbde2395b65b27bb3ec34fde829568ae7c89cb307e4ad8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f411215069892856b8b9299caf8c373622224740e26af2f26967960268f2b543"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
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
