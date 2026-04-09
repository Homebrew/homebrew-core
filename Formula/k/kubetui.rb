class Kubetui < Formula
  desc "TUI tool for monitoring and exploration of Kubernetes resources"
  homepage "https://github.com/sarub0b0/kubetui"
  url "https://github.com/sarub0b0/kubetui/archive/refs/tags/v1.12.1.tar.gz"
  sha256 "ded42ad435fdbf0c6f74f426de1cf30b816099c09ab10a4292c5384bb0c53c68"
  license "MIT"
  head "https://github.com/sarub0b0/kubetui.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3b9305fca8648e75f022caf8dbec07371fa22d71cd629c374db95b9b06bb5842"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "201fc4c226e69bee11237fc50df623c765fa5397adcab905a4c4b87310857250"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1bb67e9a6bf8bd8f9bd6c04f5f9776bcc8545ea07f24a8fca6281d169456c0ec"
    sha256 cellar: :any_skip_relocation, sonoma:        "eece04566a08188048e98504734454ca6702bdde056ddc686ea5326a15d60c4a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b9beca1a79a2f7870bc0ff2416270af1462da71e2dcbb4e381c7506fc8e05040"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "79a460dcbe770cc5b81653be2f241b0a229075749c71e350281d197129ea7f95"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"kubetui", "completion", shells: [:bash, :zsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kubetui --version")

    # Use pty because it fails with this error in Linux CI:
    #   failed to enable raw mode: Os { code: 6, kind: Uncategorized, message: "No such device or address" }
    r, _w, pid = PTY.spawn("#{bin}/kubetui --kubeconfig not_exist")

    output = ""
    begin
      r.each_line { |line| output += line }
    rescue Errno::EIO
      # GNU/Linux raises EIO when read is done on closed pty
    ensure
      Process.wait(pid)
    end

    assert_match "failed to read kubeconfig", output
    assert_equal 1, $CHILD_STATUS.exitstatus
  end
end
