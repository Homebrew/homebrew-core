class Goshs < Formula
  desc "Simple, yet feature-rich web server written in Go"
  homepage "https://goshs.de"
  url "https://github.com/goshs-labs/goshs/archive/refs/tags/v2.1.6.tar.gz"
  sha256 "788df458372340c7cf7815ec481b43c48a3f37fcda8ffa752a5ae12f47e3a303"
  license "MIT"
  head "https://github.com/goshs-labs/goshs.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "eb520e0bd2501bd16eefba6181bc033a288a5330c755b630080ddec4a1075feb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eb520e0bd2501bd16eefba6181bc033a288a5330c755b630080ddec4a1075feb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eb520e0bd2501bd16eefba6181bc033a288a5330c755b630080ddec4a1075feb"
    sha256 cellar: :any_skip_relocation, sonoma:        "79ac6a33d15614cb26b4d5937515a0f98e93fb044a6aa79d96f03b407d780984"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "948d0adb7c930ec1b24d858e59f08b184e067387f0805cee173002a065a95703"
    sha256 cellar: :any,                 x86_64_linux:  "81eca6d92e7e5758167e7e6bcbf6b8be2f7460b92bed2752dd6cb6a7c1657367"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/goshs -v")

    (testpath/"test.txt").write "Hello, Goshs!"

    port = free_port
    pid = spawn bin/"goshs", "-p", port.to_s, "-d", testpath, "-si"
    output = shell_output("curl --retry 5 --retry-connrefused -s http://localhost:#{port}/test.txt")
    assert_match "Hello, Goshs!", output
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
