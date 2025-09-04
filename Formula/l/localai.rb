class Localai < Formula
  desc "OpenAI alternative"
  homepage "https://localai.io"
  url "https://github.com/mudler/LocalAI/archive/refs/tags/v3.5.0.tar.gz"
  sha256 "b4a1fd12c3691c0e175774257a36d76f5b36503323ae0687ad058719c1513942"
  license "MIT"
  head "https://github.com/mudler/LocalAI.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "941c59ac9ae6cc710e0425bfd263a2b1e44d6bc88764d04df917f8e1e26b08f8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8dff585a80af99c821e9b919b9a0b6ea165eb813ba825989319b92fbccb8c67c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f336b73361dedf5f1c1669ff64fe221f486f062e6793de61d560f7c19c3a885f"
    sha256 cellar: :any_skip_relocation, sonoma:        "cca61a54ad7be28fc31492621ae0e34a67696222a264b108df4583d204c9fb65"
    sha256 cellar: :any_skip_relocation, ventura:       "bf42a8eb31c0b95a86f7a0f811d9e3a99e21668fa2d9503ae80c1f102fba4bfe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f003caf3787c6557af079240f5ec263761b802641d67e1fb49dfc09ea7c97e33"
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

    spawn bin/"local-ai", "run", "--address", addr
    sleep 5
    sleep 20 if OS.mac? && Hardware::CPU.intel?

    response = shell_output("curl -s -i #{addr}")
    assert_match "HTTP/1.1 200 OK", response
  end
end
