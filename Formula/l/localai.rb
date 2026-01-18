class Localai < Formula
  desc "OpenAI alternative"
  homepage "https://localai.io"
  url "https://github.com/mudler/LocalAI/archive/refs/tags/v3.9.0.tar.gz"
  sha256 "f08cfa6804d15f4ed73ada71fab881d7195b8a8810c7003a0bfd73692b63a70e"
  license "MIT"
  head "https://github.com/mudler/LocalAI.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6bde69ea46cdef55e4012c6dad23f6fe7b0ee78712cc39a64ee292bf4e9de0ad"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fca861e0bf6394b94e1f04695930de87eebc2d1af0b499d87e921c993493c40f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "32f8d2450dc2db2f6740c626ba049ca3c0c8c84e0cb9fe190e508d7ae3c370b9"
    sha256 cellar: :any_skip_relocation, sonoma:        "7d096e7ee8e244abdf96bca5eb9b6fb1ad97e754663bac7fd70b6a02358a6a5d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7a466e434e8808c0170bc7c13221143036506c6cac6ed3a75599656e004ba710"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "52e924a5b9b5dbb3695d6f2f5d68806be706b73499948f1f6f844adead5357e0"
  end

  depends_on "go" => :build
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
