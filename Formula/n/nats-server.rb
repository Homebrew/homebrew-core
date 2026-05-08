class NatsServer < Formula
  desc "Lightweight cloud messaging system"
  homepage "https://nats.io"
  url "https://github.com/nats-io/nats-server/archive/refs/tags/v2.14.0.tar.gz"
  sha256 "ba00a8ec22fe7edab11cf670137d13235c8b5d5a8c5fa5f9cb1556a6ff7c3564"
  license "Apache-2.0"
  head "https://github.com/nats-io/nats-server.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bb73fe166cd614101d54b4aa996bd7e115f2763911e4f492b59c62fa03668a6a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bb73fe166cd614101d54b4aa996bd7e115f2763911e4f492b59c62fa03668a6a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bb73fe166cd614101d54b4aa996bd7e115f2763911e4f492b59c62fa03668a6a"
    sha256 cellar: :any_skip_relocation, sonoma:        "a426fc1098ce9e508cc8698cbaca04efa600d4b3fc554c4b4949090487c9d4e1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9ad2d087092debdc6c7959d6961866a7db9fb5f0d19a5403823e3cc9cc134b14"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "977c1947e88f001da82c1785dbb883a3a9935b509a319abf870e92191db83731"
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
