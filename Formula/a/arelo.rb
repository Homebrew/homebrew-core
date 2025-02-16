class Arelo < Formula
  desc "Simple auto reload (live reload) utility"
  homepage "https://github.com/makiuchi-d/arelo"
  url "https://github.com/makiuchi-d/arelo/archive/refs/tags/v1.14.0.tar.gz"
  sha256 "44f014aece1c9032dcf887b8186701d003d87fd89609f738d70784c5e984d1dd"
  license "MIT"
  head "https://github.com/makiuchi-d/arelo.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "975eb1633c6ffcee068cea3aa392dfa28173111b0a4ddba8317b9aecc3beacef"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "975eb1633c6ffcee068cea3aa392dfa28173111b0a4ddba8317b9aecc3beacef"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "975eb1633c6ffcee068cea3aa392dfa28173111b0a4ddba8317b9aecc3beacef"
    sha256 cellar: :any_skip_relocation, sonoma:        "82c759c685e7c8f2cd5ee2b5af91d8a0036218c080c336b3657c153ed6eef8a2"
    sha256 cellar: :any_skip_relocation, ventura:       "82c759c685e7c8f2cd5ee2b5af91d8a0036218c080c336b3657c153ed6eef8a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1ad820c73cac71c8c312e2f61db8d284eb91fdab5678eb20f91dc41658de4854"
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
