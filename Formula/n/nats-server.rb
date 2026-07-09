class NatsServer < Formula
  desc "Lightweight cloud messaging system"
  homepage "https://nats.io"
  url "https://github.com/nats-io/nats-server/archive/refs/tags/v2.14.3.tar.gz"
  sha256 "dba5286035ce9017b897ea24a783551dc28b07ad50c78da5471ead2bcfab3e86"
  license "Apache-2.0"
  head "https://github.com/nats-io/nats-server.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "739eb647b9c1307f4d8f3059b304064419f0523ed201d20dc2999c60302aef25"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "739eb647b9c1307f4d8f3059b304064419f0523ed201d20dc2999c60302aef25"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "739eb647b9c1307f4d8f3059b304064419f0523ed201d20dc2999c60302aef25"
    sha256 cellar: :any_skip_relocation, sonoma:        "cb20e833d874815872a54cd751165cb8bce8ca5b6fee4fe7c0fe3f3efefe161f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a246209d414e988b1648ea2bfa63c811c4b33a2e3f58f1d0567a64679d928d26"
    sha256 cellar: :any,                 x86_64_linux:  "e080aeb1a712bf2f772092f43ab0d2022b92ef5f74279adda74d03beab4f7acf"
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
    spawn bin/"nats-server",
          "--port=#{port}",
          "--http_port=#{http_port}",
          "--pid=#{testpath}/pid",
          "--log=#{testpath}/log"
    sleep 3

    assert_match version.to_s, shell_output("curl localhost:#{http_port}/varz")
    assert_path_exists testpath/"log"
  end
end
