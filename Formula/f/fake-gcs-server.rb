class FakeGcsServer < Formula
  desc "Emulator for Google Cloud Storage API"
  homepage "https://github.com/fsouza/fake-gcs-server"
  url "https://github.com/fsouza/fake-gcs-server/archive/refs/tags/v1.52.3.tar.gz"
  sha256 "ef7d6719d9a824a5614808c9408bd3dd73dda1049feaa7f65442b1c44602aa13"
  license "BSD-2-Clause"
  head "https://github.com/fsouza/fake-gcs-server.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e6cf95118b41871dd78746325abf6365f28bfdb20177a5ab2619267ad07ada08"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e6cf95118b41871dd78746325abf6365f28bfdb20177a5ab2619267ad07ada08"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e6cf95118b41871dd78746325abf6365f28bfdb20177a5ab2619267ad07ada08"
    sha256 cellar: :any_skip_relocation, sonoma:        "818e78af6caa0a6d4cb75c4b02abeff3a7370764d56362f2c86ae5270688571d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6f070f1fde54cff07e25dc556a39171277265d0ed8b3b24cea4519d50b477cfc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8ec981d8f8814f3367950009e918675f5fabde407ea3f89997dea7569f60deb1"
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
