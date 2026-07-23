class KubectlKlock < Formula
  desc "Kubectl plugin to render watch output in a more readable fashion"
  homepage "https://github.com/applejag/kubectl-klock"
  url "https://github.com/applejag/kubectl-klock/archive/refs/tags/v0.9.1.tar.gz"
  sha256 "3356d126bed9d9c0f39e9c788bd203dd3ab7c2c3734934814cdd4750a16ef36e"
  license all_of: ["GPL-3.0-or-later", "CC0-1.0"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8bdb704fcf69194e853b36ee3180c38bec999282df98d0fc0a47a74729c8f182"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9f19de165f53c667c5f8ef2d1fe70c45e963decabacef111aa2d1e73f8528bf9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5f73c311f056774abf94c073182c57da5f04285b5a004b3fc704097ed3ad7cf4"
    sha256 cellar: :any_skip_relocation, sonoma:        "3a75a17598947f6475fe14055161895180d8ec2cc1cacc7bd18d19ef74501751"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "629aaae14097a89a1ee17cbe25f76199d0ff7d2586384c6f903921e18ece3634"
    sha256 cellar: :any,                 x86_64_linux:  "39e81a497b7bc1c6f9d1e8393b5282aa3d2dac148e20748cf729da6a3eb156e3"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
    generate_completions_from_executable(bin/"kubectl-klock", shell_parameter_format: :cobra)
    bin.install "bin/kubectl_complete-klock"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kubectl-klock --version")

    output = ""
    PTY.spawn "#{bin}/kubectl-klock pods" do |r, _w, pid|
      sleep 1
      Process.kill("TERM", pid)
      begin
        r.each_line { |line| output += line }
      rescue Errno::EIO
        # GNU/Linux raises EIO when read is done on closed pty
      end
    end
    assert_match "connect: connection refused", output
  end
end
