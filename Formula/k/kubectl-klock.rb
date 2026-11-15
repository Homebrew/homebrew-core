class KubectlKlock < Formula
  desc "Kubectl plugin to render watch output in a more readable fashion"
  homepage "https://github.com/applejag/kubectl-klock"
  url "https://github.com/applejag/kubectl-klock/archive/refs/tags/v0.9.3.tar.gz"
  sha256 "98f28a0d32a5cd0bd07f6d4dc12fd8f1ef069dba176f222540b31e3689366719"
  license all_of: ["GPL-3.0-or-later", "CC0-1.0"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "8a4681cc233eadd8ed81bfc6479e7675fe8edacf699e0d29dc2a84932345c8e1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f29b9279987a99360dda140780976b30a440e856ed1282a9e2b18d200988fc09"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f1baf999ff858612bb0a8036e0306fe178e661a4de0004a327e21fceed3c0c81"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "918fa237fd7a6fdce41c33a83e68621d01559a1a40b9c9335603b29cf83f3484"
    sha256 cellar: :any,                 x86_64_linux:      "6f04cc1e39ee523d2106a1cb3a5556676c057101916b0c52ddfd5f750c81ec22"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}")
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
