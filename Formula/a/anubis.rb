class Anubis < Formula
  desc "Protect resources from scraper bots"
  homepage "https://anubis.techaro.lol"
  url "https://github.com/TecharoHQ/anubis/archive/refs/tags/v1.19.1.tar.gz"
  sha256 "5fa0640abad46d1cbe5a84063ec60caa3272478044bad3e1e8b0260ee8756ce7"
  license "MIT"
  head "https://github.com/TecharoHQ/anubis.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ffcb9cd038e147a4e4aab9ffda6472b12737a8763aeccf8d046b187fa098aa9c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "19a3533a753225e8e7118e94ee4f11e19d3e8a816acd3aae96c03ea9e9a1230b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0f083df38b52274a0e69b9480f0bfb2b710e38db27b0d1ad290ff3c7221d79d6"
    sha256 cellar: :any_skip_relocation, sonoma:        "5682dcbd0dfe7976c83e342269c4c17024b5679a5d9ca7053561ec5717b294da"
    sha256 cellar: :any_skip_relocation, ventura:       "67ccc6acdca2a741e4fa9f9fa922d6e5461a88a47acf8ab7e933620cbcf9b095"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b1f51ff69339768fa16ef116c7ba89f4455ca14bb6de82842d15c11aa62b3d88"
  end

  depends_on "go" => :build
  depends_on "webify" => :test

  def install
    ldflags = "-s -w -X github.com/TecharoHQ/anubis.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/anubis"
  end

  test do
    webify_port = free_port
    anubis_port = free_port

    webify_pid = spawn Formula["webify"].opt_bin/"webify", "-addr", ":#{webify_port}", "echo", "Homebrew"
    anubis_pid = spawn bin/"anubis", "-bind", ":#{anubis_port}", "-target", "http://localhost:#{webify_port}",
      "-serve-robots-txt", "-use-remote-address", "127.0.0.1"

    assert_includes shell_output("curl --silent --retry 5 --retry-connrefused http://localhost:#{anubis_port}"),
      "Homebrew"

    expected_robots_txt = <<~EOS
      User-agent: *
      Disallow: /
    EOS
    assert_includes shell_output("curl --silent http://localhost:#{anubis_port}/robots.txt"),
      expected_robots_txt.strip
  ensure
    Process.kill "TERM", anubis_pid
    Process.kill "TERM", webify_pid
    Process.wait anubis_pid
    Process.wait webify_pid
  end
end
