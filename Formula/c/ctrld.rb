class Ctrld < Formula
  desc "Highly configurable, multi-protocol DNS forwarding proxy"
  homepage "https://github.com/Control-D-Inc/ctrld"
  url "https://github.com/Control-D-Inc/ctrld/archive/refs/tags/v1.4.9.tar.gz"
  sha256 "7330daba75b3ebfa819a2017265e05ed08cd0aaf050e98c87ae777483a1d2491"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ec4357c6b91023d31be6b5230885166118df8760c9b67d4e8c456662a998c994"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ec4357c6b91023d31be6b5230885166118df8760c9b67d4e8c456662a998c994"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ec4357c6b91023d31be6b5230885166118df8760c9b67d4e8c456662a998c994"
    sha256 cellar: :any_skip_relocation, sonoma:        "57e39011343a9dd05d402b61dae82d2b6537b250984525b860ad1cdee38789e8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5ac01cc0ee8244a34f96a8d986c20041be358ba4127af5ef94c4e9dced344136"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "51feab86ea1915f33ce80f722b8e174df2cf10ed98f01e3ae6d55a1f680687e8"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
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
