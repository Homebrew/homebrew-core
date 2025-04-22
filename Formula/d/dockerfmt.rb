class Dockerfmt < Formula
  desc "Dockerfile format and parser. a modern dockfmt"
  homepage "https://github.com/reteps/dockerfmt"
  url "https://github.com/reteps/dockerfmt/archive/refs/tags/v0.3.6.tar.gz"
  sha256 "ce9f67ea2513cda0d04a26d11c80300a834242eee0656797901254ccb0c89553"
  license "MIT"
  head "https://github.com/reteps/dockerfmt.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "74ec6747b0589a7f1bb7185e1576d847ce7c182039233b12600905ab93b122df"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "74ec6747b0589a7f1bb7185e1576d847ce7c182039233b12600905ab93b122df"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "74ec6747b0589a7f1bb7185e1576d847ce7c182039233b12600905ab93b122df"
    sha256 cellar: :any_skip_relocation, sonoma:        "ac2b50117b3436870b6110a7342911a422f28edccf6278e0467a094c1524893e"
    sha256 cellar: :any_skip_relocation, ventura:       "ac2b50117b3436870b6110a7342911a422f28edccf6278e0467a094c1524893e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1aeb3ba38382f7bc0070773ebf5417bd06bdeddb40635a3b27022df5d16f7a16"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
    generate_completions_from_executable(bin/"dockerfmt", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dockerfmt version")

    (testpath/"Dockerfile").write <<~DOCKERFILE
      FROM alpine:latest
    DOCKERFILE

    output = shell_output("#{bin}/dockerfmt --check Dockerfile 2>&1", 1)
    assert_match "Dockerfile is not formatted", output
  end
end
