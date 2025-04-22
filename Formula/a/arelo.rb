class Arelo < Formula
  desc "Simple auto reload (live reload) utility"
  homepage "https://github.com/makiuchi-d/arelo"
  url "https://github.com/makiuchi-d/arelo/archive/refs/tags/v1.15.2.tar.gz"
  sha256 "9b2f0013ccb00667b79e7ef65e8d0e97fb996cc1a3d0b98489dccbc97e003f0f"
  license "MIT"
  head "https://github.com/makiuchi-d/arelo.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8998f272c4bf308c307d4437077ea5a524eaa0f6e13415f95033fa4f9d8a1da5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8998f272c4bf308c307d4437077ea5a524eaa0f6e13415f95033fa4f9d8a1da5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8998f272c4bf308c307d4437077ea5a524eaa0f6e13415f95033fa4f9d8a1da5"
    sha256 cellar: :any_skip_relocation, sonoma:        "7cf59394f7a1b29624a3ce23622b25f9343467b738b3086f580c66ca50f3985c"
    sha256 cellar: :any_skip_relocation, ventura:       "7cf59394f7a1b29624a3ce23622b25f9343467b738b3086f580c66ca50f3985c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fb4876ce285bfd79b2e75ffd5ffbcab215566d42afa135294bfd6ef2b5f21e06"
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
