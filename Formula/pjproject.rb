class Pjproject < Formula
  desc "C library for multimedia protocols such as SIP, SDP, RTP and more"
  homepage "https://www.pjsip.org/"
  url "https://github.com/pjsip/pjproject/archive/2.12.1.tar.gz"
  sha256 "d0feef6963b07934e821ba4328aecb4c36358515c1b3e507da5874555d713533"
  license "GPL-2.0-or-later"
  head "https://github.com/pjsip/pjproject.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "2db71a49fb481857c6ce497a221f602fa07b7b6d08828c234038b718d5b1f404"
    sha256 cellar: :any,                 arm64_monterey: "143bd078228ec92a6416969f04ead2de05973846e5a349bf7bb4dd46cac0424f"
    sha256 cellar: :any,                 arm64_big_sur:  "b50e7a156e26862cfd37552756561a684c0a407ec2fc16e1352c5efc43a759cf"
    sha256 cellar: :any,                 monterey:       "2fe4e4d2240639c150596b5cb8a9cd33f590f0c61bb3e543c05459350ceb9203"
    sha256 cellar: :any,                 big_sur:        "fbeca53f3d5e13d3a768e47530e2b97f37b1d1d8826444be6d63636216380782"
    sha256 cellar: :any,                 catalina:       "3b3d7981a5d9754c742fd5c052188d0dd0d5dfaff0152190560c0f1c22223e1f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fa28b3a2157f3da4379c83e44fc08018ab97015a3f0102e5e9a00ab7fb1bc6cb"
  end

  depends_on macos: :high_sierra # Uses Security framework API enum cases introduced in 10.13.4
  depends_on "openssl@3"

  # restore --version flag, remove in next version
  patch do
    url "https://github.com/pjsip/pjproject/commit/4a8cf9f3.patch?full_index=1"
    sha256 "2a343db0ba4c0cb02ebaa4fc197b27aa9ef064f8367f02f77b854204ff640112"
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    ENV.deparallelize
    system "make", "dep"
    system "make"
    system "make", "install"

    arch = (OS.mac? && Hardware::CPU.arm?) ? "arm" : Hardware::CPU.arch.to_s
    target = OS.mac? ? "apple-darwin#{OS.kernel_version}" : "unknown-linux-gnu"

    bin.install "pjsip-apps/bin/pjsua-#{arch}-#{target}" => "pjsua"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pjsua --version 2>&1")
  end
end
