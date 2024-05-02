class Cotp < Formula
  desc "TOTP/HOTP authenticator app with import functionality"
  homepage "https://github.com/replydev/cotp"
  url "https://github.com/replydev/cotp/archive/refs/tags/v1.5.0.tar.gz"
  sha256 "3a868e3bbb0794a2f9baee571f43fcded4029ed92ddfeccfa2b4ee54e6e0c927"
  license "GPL-3.0-only"
  head "https://github.com/replydev/cotp.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1807ac281480ec01eb10bcecfbcfcc400188897b88e887816dfe31009ef7af81"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cbd3500e014dc6fa197e31d68d3c00f33e18c3e6e8208ef9a3f791a4c4cdaaa4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8ea0c4db93925a5b422c8b36ca46e46d62d254c7cbdeee5bbfb4457ca370160a"
    sha256 cellar: :any_skip_relocation, sonoma:         "cf06881a109d3c620dc841d2a2f25d5ade1f37659dce8149b4f79bcc4161507f"
    sha256 cellar: :any_skip_relocation, ventura:        "50302e92aca1fb6bb3e8c2c5630a7dc965e62cffc860e394f638654c9bc6b45c"
    sha256 cellar: :any_skip_relocation, monterey:       "eefd4de121c1770f26c26f43e4961da8a5b197f1398c60fe90f4dba2266477db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d54947061d528219c5f0dda7ced6e8beb5deabafc81e149c495c07d97f5504f3"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Proper test needs password input, so use error message for executable check
    assert_match <<~EOS, shell_output("#{bin}/cotp edit 2>&1", 2)
      error: the following required arguments were not provided:
        --index <INDEX>
    EOS

    assert_match version.to_s, shell_output("#{bin}/cotp --version")
  end
end
