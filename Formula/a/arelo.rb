class Arelo < Formula
  desc "Simple auto reload (live reload) utility"
  homepage "https://github.com/makiuchi-d/arelo"
  url "https://github.com/makiuchi-d/arelo/archive/refs/tags/v1.15.3.tar.gz"
  sha256 "7726530e551200ae2cf932518566cc903d1dcc02b587c795382ee291e11ccbf9"
  license "MIT"
  head "https://github.com/makiuchi-d/arelo.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ef538d5b66f8ac04b533621fbfb9fcedc6d5fd0c540b832eb10b4aed0c8098d4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ef538d5b66f8ac04b533621fbfb9fcedc6d5fd0c540b832eb10b4aed0c8098d4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ef538d5b66f8ac04b533621fbfb9fcedc6d5fd0c540b832eb10b4aed0c8098d4"
    sha256 cellar: :any_skip_relocation, sonoma:        "95009e62522504a0a89f00aab23bceab8f11cc8353d2f00f86d4577992987d5a"
    sha256 cellar: :any_skip_relocation, ventura:       "95009e62522504a0a89f00aab23bceab8f11cc8353d2f00f86d4577992987d5a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "11eb0e7d3d3e786a081dc9cbc26aad40497e20dddd4782504a5043fac54bf845"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/arelo --version")

    (testpath/"test.sh").write <<~EOS
      #!/bin/sh
      echo "Hello, world!"
    EOS
    chmod 0755, testpath/"test.sh"

    logfile = testpath/"arelo.log"
    arelo_pid = spawn bin/"arelo", "--pattern", "test.sh", "--", "./test.sh", out: logfile.to_s

    sleep 1
    touch testpath/"test.sh"
    sleep 1

    assert_path_exists testpath/"test.sh"
    assert_match "Hello, world!", logfile.read
  ensure
    Process.kill("TERM", arelo_pid)
    Process.wait(arelo_pid)
  end
end
