class Ctrld < Formula
  desc "Highly configurable, multi-protocol DNS forwarding proxy"
  homepage "https://github.com/Control-D-Inc/ctrld"
  url "https://github.com/Control-D-Inc/ctrld/archive/refs/tags/v1.4.7.tar.gz"
  sha256 "2842b983c4fa7726073596ebf2bcbeb53e1932c1c1f061e49b636cb5327d7ba4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "aa1d8f3181a7ef21c13128a232cb9a2c9db4880658b6a844b9f6533d6e82195a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aa1d8f3181a7ef21c13128a232cb9a2c9db4880658b6a844b9f6533d6e82195a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aa1d8f3181a7ef21c13128a232cb9a2c9db4880658b6a844b9f6533d6e82195a"
    sha256 cellar: :any_skip_relocation, sonoma:        "f73a8919ef8d3a5f6b449490e3a13c38d80aba2366c712fd10f69ff4d46fe5b1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6722b92d1883ae94828b8f529f2a4ded2252c8e4af1d4646cc843ecb8e35bf91"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7b57fe6595f991cf2d951dcad47167e2b15928dfa4adc231014710c8dad741f8"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/Control-D-Inc/ctrld/cmd/cli.version=#{version}
      -X github.com/Control-D-Inc/ctrld/cmd/cli.commit=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/ctrld"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ctrld --version")

    output_log = testpath/"output.log"
    pid = spawn bin/"ctrld", "start", [:out, :err] => output_log.to_s
    sleep 3
    assert_match "Please relaunch process with admin/root privilege.", output_log.read
  ensure
    Process.kill "TERM", pid
    Process.wait pid
  end
end
