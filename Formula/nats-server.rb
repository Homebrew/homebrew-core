class NatsServer < Formula
  desc "Lightweight cloud messaging system"
  homepage "https://nats.io"
  url "https://github.com/nats-io/nats-server/archive/refs/tags/v2.6.2.tar.gz"
  sha256 "fbbad2370bc92a548e9a797b941c79b19d7affd5b1db622229afbf043f9932fe"
  license "Apache-2.0"
  head "https://github.com/nats-io/nats-server.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e4b9d73e8e66f696690941e0312913af172ba26354c2da4c8e48169705b8a7eb"
    sha256 cellar: :any_skip_relocation, big_sur:       "6304c771f4b7b2ffa0497dabbfaceb4807cdc4d51f57a6c148f8c952b4504b24"
    sha256 cellar: :any_skip_relocation, catalina:      "beb84d27dcd93bdd5c4c303ed37cadaadd5babf88077411880116216fe1284f7"
    sha256 cellar: :any_skip_relocation, mojave:        "433090bbb534eadd53cbcb303d37119e67d79dc53bb03ac6523b6519cdde2628"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0746efe909395c1926e4af6bd2d77b8cc3e2265c2d7efa3e26e4a3fe30d97743"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags", "-s -w", *std_go_args
  end

  service do
    run opt_bin/"nats-server"
  end

  test do
    port = free_port
    fork do
      exec bin/"nats-server",
           "--port=#{port}",
           "--pid=#{testpath}/pid",
           "--log=#{testpath}/log"
    end
    sleep 3

    assert_match version.to_s, shell_output("curl localhost:#{port}")
    assert_predicate testpath/"log", :exist?
  end
end
