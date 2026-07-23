class Ctrld < Formula
  desc "Highly configurable, multi-protocol DNS forwarding proxy"
  homepage "https://github.com/Control-D-Inc/ctrld"
  url "https://github.com/Control-D-Inc/ctrld/archive/refs/tags/v1.5.4.tar.gz"
  sha256 "d9503c45a6de0885797e6f82bf1975a7b830ee68a131cfd439e60b717654e4c4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8ff0d30ff595611e0b9c04b4ce3aa51e3d631ce8a3ab782e988c161b45180d47"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8ff0d30ff595611e0b9c04b4ce3aa51e3d631ce8a3ab782e988c161b45180d47"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8ff0d30ff595611e0b9c04b4ce3aa51e3d631ce8a3ab782e988c161b45180d47"
    sha256 cellar: :any_skip_relocation, sonoma:        "7b1d174cf0ae952761e0120f7615c0d73023f288f41bb63a1bcf2d18bd8916b1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "283ce3222c7261bb38dd2d8cb97bddf8d5bb279bc625a9be57716488a970f397"
    sha256 cellar: :any,                 x86_64_linux:  "2a2d93d672c71564830c8e9d2adbd0ab888844d4cc7f2b83e1ebbe5168381e85"
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
