class Localai < Formula
  desc "OpenAI alternative"
  homepage "https://localai.io"
  url "https://github.com/mudler/LocalAI/releases/download/v5.0.0/LocalAI-v5.0.0-source.tar.gz"
  sha256 "8879ff68b4356bef0c14997609d2e9740c4fbbbe62e8428e621286b9c5aaf42e"
  license "MIT"
  head "https://github.com/mudler/LocalAI.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "3929247d712ff9aee135690b9c68b9dfd951070fe8bc269531d10d064cbb2200"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "8fd388329480f98324a7d0391d8cfd3861928c8e6e4b90ac397a297848db2189"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "930c6a4a68d6665e3e68658788cd5908319e9757e2e21aed9a5545b5efa187e4"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "9ca2e46c9f881d52d7c3be7d7f1ccddc473e00b2951d638e19f5c0923471bd94"
    sha256 cellar: :any,                 x86_64_linux:      "47875d79f3ffc8011f13d570d204148273ce68ebeff58cb050facaee0641e750"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "protobuf" => :build
  depends_on "protoc-gen-go" => :build
  depends_on "protoc-gen-go-grpc" => :build

  def install
    ENV["SDKROOT"] = MacOS.sdk_path if OS.mac?

    system "make", "build", "VERSION=#{version}"
    bin.install "local-ai"
  end

  test do
    addr = "127.0.0.1:#{free_port}"

    # The add-on owner opens `/` at startup, which the Linux test sandbox denies
    pid = spawn bin/"local-ai", "run", "--address", addr, "--addons-enabled=false"
    sleep 5

    begin
      response = shell_output("curl -s -i #{addr}/readyz")
      assert_match "HTTP/1.1 200 OK", response
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
