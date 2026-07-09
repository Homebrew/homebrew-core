class Localai < Formula
  desc "OpenAI alternative"
  homepage "https://localai.io"
  url "https://github.com/mudler/LocalAI/archive/refs/tags/v4.6.2.tar.gz"
  sha256 "cb593343588fc0a9a0d18c24f00a0b6bb751592f4bd614719b8d17aefaa6fc6c"
  license "MIT"
  head "https://github.com/mudler/LocalAI.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "87eac674b49d25fb4b8db6f6211c39f15fd406295264b783a09b23be70a1b338"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1ba823d7a6d4e4b48f526e107ac500ab96edec27c4b15d04d5fbe556fbb2567d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a54417df6b56e82e2070c88bbca3862325f47ef6ec82a295e83afe5098637e4f"
    sha256 cellar: :any_skip_relocation, sonoma:        "29de858ab2af2c3fccdd957b028d6fe3b5cbc7d410a8a816b9f1c4a4f89c5994"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "faf82aeadd9fcda7f379fd5d40c7342287bdc6affbfecba87a479b70646ee811"
    sha256 cellar: :any,                 x86_64_linux:  "798d51db36ec66fc4e1f97fea01f8c09cc524995e7f307ea2d295373bd1328b1"
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

    pid = spawn bin/"local-ai", "run", "--address", addr
    sleep 5
    sleep 20 if OS.mac? && Hardware::CPU.intel?

    begin
      response = shell_output("curl -s -i #{addr}/readyz")
      assert_match "HTTP/1.1 200 OK", response
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
