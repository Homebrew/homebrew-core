class FakeGcsServer < Formula
  desc "Emulator for Google Cloud Storage API"
  homepage "https://github.com/fsouza/fake-gcs-server"
  url "https://github.com/fsouza/fake-gcs-server/archive/refs/tags/v1.55.1.tar.gz"
  sha256 "5f808ab6211019e255e356a0c7f2b542f2a34481c2dffe043244060c9432fdc8"
  license "BSD-2-Clause"
  head "https://github.com/fsouza/fake-gcs-server.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ca352957125ff9a9ece682a92641baaa030f15d5d732b5e3877bd4b9ce588af6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ca352957125ff9a9ece682a92641baaa030f15d5d732b5e3877bd4b9ce588af6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ca352957125ff9a9ece682a92641baaa030f15d5d732b5e3877bd4b9ce588af6"
    sha256 cellar: :any_skip_relocation, sonoma:        "c1ca9f3f908e36bc97ae2754c9d1237814f3be992563f11e777582b9d7d16736"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e2e6e810877abef3d6de0acdbfd8f25d2aa63340df3def6c0e178ed9af16b7b0"
    sha256 cellar: :any,                 x86_64_linux:  "323fee424547fe553d185e142a92165b99734c9142c388a6eb78d340a7d8da54"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/fsouza/fake-gcs-server.Version=#{version}"
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
