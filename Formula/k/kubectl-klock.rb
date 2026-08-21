class KubectlKlock < Formula
  desc "Kubectl plugin to render watch output in a more readable fashion"
  homepage "https://github.com/applejag/kubectl-klock"
  url "https://github.com/applejag/kubectl-klock/archive/refs/tags/v0.9.2.tar.gz"
  sha256 "57c69971602520f02ef4ccf20c30065dddd0122fe9e208159f3d87cd22d025e5"
  license all_of: ["GPL-3.0-or-later", "CC0-1.0"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "718ec67a9be82616939817ef908a73d1cf093889fb59e981bd07c99b64609c3a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8e30f7f70df92acb2446f7c18e83960c2b45fcfd2615a329469fdbf8fc1e81af"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "74dc015bb6e0ad8ec31e19fac79e83d192c6c7fe0e5c4e572906c515cf75a984"
    sha256 cellar: :any_skip_relocation, sonoma:        "07dd21c3a5707d28f41b299a146ab9b6b76fcc63c79720a84fb3b772473d9b6d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5f5dfaa5ccd5cc1efde16768eb7fb756efd69cef3922aea87a42783a4d365a94"
    sha256 cellar: :any,                 x86_64_linux:  "c3daa7a5ba2c30ce3547ee369f9e969ad5bcb28f435b2139a8542aa44aacb346"
  end

  depends_on "go" => :build

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
