class Httm < Formula
  desc "Interactive, file-level Time Machine-like tool for ZFS/btrfs"
  homepage "https://github.com/kimono-koans/httm"
  url "https://github.com/kimono-koans/httm/archive/refs/tags/0.24.1.tar.gz"
  sha256 "687a926de3c97820ecfbe43a21220afc8b0180c30091932fa1bbeb47e0758228"
  license "MPL-2.0"
  head "https://github.com/kimono-koans/httm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1a559ee51eeb0277e55f84a28a05c1b88d97ce38e12c6ff176acd6d135908b3a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "786b7d2f67839d69c081e3d1dec052ab80aca9509403541c09591cfa362f9475"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d1c8846ee944858354c34fd8b61fbc863a2c4f0470d700936e535538a6be3a47"
    sha256 cellar: :any_skip_relocation, ventura:        "73249b6a42e74dcfe7b922f04ceaa6accf864ec18d084f6b2b661ccd03ac6c9f"
    sha256 cellar: :any_skip_relocation, monterey:       "14ae7be00803ca355136c4a43df5b87a33fdab34430c4b6316d6f44029f8a0b7"
    sha256 cellar: :any_skip_relocation, big_sur:        "c357bcc77a82a47591c3967b78d8732d551f739d077ffbe3be5ee46dbbd6845a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b42a9b843dad0dc143003cd186ad1af6c49d30a53e1f38d24b15534451f46886"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    man1.install "httm.1"
  end

  test do
    touch testpath/"foo"
    assert_equal "Error: httm could not find any valid datasets on the system.",
      shell_output("#{bin}/httm #{testpath}/foo 2>&1", 1).strip
    assert_equal "httm #{version}", shell_output("#{bin}/httm --version").strip
  end
end
