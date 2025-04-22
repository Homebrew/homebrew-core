class NatsServer < Formula
  desc "Lightweight cloud messaging system"
  homepage "https://nats.io"
  url "https://github.com/nats-io/nats-server/archive/refs/tags/v2.11.1.tar.gz"
  sha256 "a49ad29b3bfc2fbe3108d4bca928c9115f9e4d0e9fc3975b0e7b47f274ef58e6"
  license "Apache-2.0"
  head "https://github.com/nats-io/nats-server.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ca845299305af880e92906e5dda71d084b75f8810437da6a6c265aafccc35626"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ca845299305af880e92906e5dda71d084b75f8810437da6a6c265aafccc35626"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ca845299305af880e92906e5dda71d084b75f8810437da6a6c265aafccc35626"
    sha256 cellar: :any_skip_relocation, sonoma:        "c1b4da1b29ba02325553c560b8d5c5b6af11290e200656798db74d99df1c3c53"
    sha256 cellar: :any_skip_relocation, ventura:       "c1b4da1b29ba02325553c560b8d5c5b6af11290e200656798db74d99df1c3c53"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "311527c7f7c95c226aef424a601e17c60c83c762f90d3d057f42375501d26f91"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  service do
    run opt_bin/"nats-server"
  end

  test do
    port = free_port
    http_port = free_port
    fork do
      exec bin/"nats-server",
           "--port=#{port}",
           "--http_port=#{http_port}",
           "--pid=#{testpath}/pid",
           "--log=#{testpath}/log"
    end
    sleep 3

    assert_match version.to_s, shell_output("curl localhost:#{http_port}/varz")
    assert_path_exists testpath/"log"
  end
end
