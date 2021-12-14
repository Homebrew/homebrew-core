class PamReattach < Formula
  desc "PAM module for reattaching to the user's GUI (Aqua) session"
  homepage "https://github.com/fabianishere/pam_reattach"
  url "https://github.com/fabianishere/pam_reattach/archive/v1.2.tar.gz"
  sha256 "60133388c400a924ca05ee0e5e6f9cc74c9f619bf97e545afe96f35544b0d011"
  license "MIT"
  head "https://github.com/fabianishere/pam_reattach.git", branch: "master"

  depends_on "cmake" => :build
  depends_on :macos

  def install
    system "cmake", ".", *std_cmake_args, "-DENABLE_CLI=ON"
    system "make", "install"
  end

  test do
    assert_match("Darwin", shell_output("#{bin}/reattach-to-session-namespace uname"))
  end
end
