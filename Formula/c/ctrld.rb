class Ctrld < Formula
  desc "Highly configurable, multi-protocol DNS forwarding proxy"
  homepage "https://github.com/Control-D-Inc/ctrld"
  url "https://github.com/Control-D-Inc/ctrld/archive/refs/tags/v1.5.5.tar.gz"
  sha256 "8d5c826708d36ab68f6a37a7bb980ff312be92a117df086e2db98f8999671cca"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "50f0eafc0bffeda52f499941ad915232efb5b13f1d64e4ff2a5a3fe0f79b5d5a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "50f0eafc0bffeda52f499941ad915232efb5b13f1d64e4ff2a5a3fe0f79b5d5a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "50f0eafc0bffeda52f499941ad915232efb5b13f1d64e4ff2a5a3fe0f79b5d5a"
    sha256 cellar: :any_skip_relocation, sonoma:        "5ac250a7fb5c9df18f444aa3888b6bfd768f5cecba9986568229ce2cc307ef34"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6c07ae11148d0fa00592387850a1285e5aa9839166fd1d0536db2166aec0c234"
    sha256 cellar: :any,                 x86_64_linux:  "b96ca814c861dfa0d76f53c8368194f26d19cebaf57d6220ff806e9c15c3a569"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -X github.com/Control-D-Inc/ctrld/cmd/cli.version=#{version}
      -X github.com/Control-D-Inc/ctrld/cmd/cli.commit=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/ctrld"
    generate_completions_from_executable(bin/"ctrld", shell_parameter_format: :cobra)
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
