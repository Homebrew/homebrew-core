class FakeGcsServer < Formula
  desc "Emulator for Google Cloud Storage API"
  homepage "https://github.com/fsouza/fake-gcs-server"
  url "https://github.com/fsouza/fake-gcs-server/archive/refs/tags/v1.56.1.tar.gz"
  sha256 "a322297f949d5339a8e521eb15a35b80c8023f970b0f6511a7bb84e72932ca2c"
  license "BSD-2-Clause"
  head "https://github.com/fsouza/fake-gcs-server.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "09cc9a797930a9cd579a0db109fb0687920a20b98b1902a325f1ec9828977bd0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "09cc9a797930a9cd579a0db109fb0687920a20b98b1902a325f1ec9828977bd0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "09cc9a797930a9cd579a0db109fb0687920a20b98b1902a325f1ec9828977bd0"
    sha256 cellar: :any_skip_relocation, sonoma:        "db7bbf7e644c9ddfdbe990bf0afb342067508a6267a4438e20faf220be88f7c5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d1a1677d834a9c8088c95f9099ebefdb2c86dc90322996256d5d6b4f9733fd0c"
    sha256 cellar: :any,                 x86_64_linux:  "7d05fae639d582f0821930036a2602157da8d22f2b573b7f282d6f14a4328289"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X github.com/fsouza/fake-gcs-server.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    port = free_port

    pid = spawn bin/"fake-gcs-server", "-host", "127.0.0.1", "-port", port.to_s,
                    "-backend", "memory", "-log-level", "warn"
    sleep 2

    begin
      output = shell_output("curl -k -s 'https://127.0.0.1:#{port}/storage/v1/b?project=test'")
      assert_equal "{\"kind\":\"storage#buckets\"}", output.strip

      # Create a bucket
      shell_output("curl -k -s -X POST 'https://127.0.0.1:#{port}/storage/v1/b?project=test' " \
                   "-H 'Content-Type: application/json' -d '{\"name\": \"test-bucket\"}'")

      # Verify bucket exists
      output = shell_output("curl -k -s 'https://127.0.0.1:#{port}/storage/v1/b?project=test'")
      assert_equal "test-bucket", JSON.parse(output)["items"][0]["id"]
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
