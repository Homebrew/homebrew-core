class Kubetui < Formula
  desc "TUI tool for monitoring and exploration of Kubernetes resources"
  homepage "https://github.com/sarub0b0/kubetui"
  url "https://github.com/sarub0b0/kubetui/archive/refs/tags/v1.5.1.tar.gz"
  sha256 "6294b4fa3d85da1b6581a88aeec9bc98a939d42893791c125d4f0e77a06d338f"
  license "MIT"
  head "https://github.com/sarub0b0/kubetui.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5f37b07a4c616e02c02b423151058ce57f3c0fc93d1f7266f92f05e90b98fab7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3e823bb6829f65d92c53b9d901f86250dc185e9b1a1e681e50a1da34024afedf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2a276e5367bad09ef9f66fcd9b47a17ee7a27930a419041fb1c5e6fb3da8e766"
    sha256 cellar: :any_skip_relocation, sonoma:         "5d47f7ffc281b4dc3c417179ccb91ff12c9881401c255fac171bf41173e3072c"
    sha256 cellar: :any_skip_relocation, ventura:        "cdb0a5eac2435f7320753f8bbca74583135211acfcec9e4f568cbfad385ba7b1"
    sha256 cellar: :any_skip_relocation, monterey:       "48e2088f778390b4e92e336d04c00d2f5b485d867fd6b078b56ae7a15c6163e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c2b068c953d03aa08476b1ca821c56baba313f353b903cdee15ffee085a966ee"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
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
