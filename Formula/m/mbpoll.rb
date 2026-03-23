class Mbpoll < Formula
  desc "Command-line utility to communicate with ModBus slave (RTU or TCP)"
  homepage "https://epsilonrt.fr"
  url "https://github.com/epsilonrt/mbpoll/archive/refs/tags/v1.5.4.tar.gz"
  sha256 "a9bcc3afa3b85b3794505d07827873ead280d96a94769d236892eb8a4fb9956f"
  license "GPL-3.0-only"
  head "https://github.com/epsilonrt/mbpoll.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "10b1218b9b816f0931d893ce7cc81f3e1af5a0cd16933c7bb299122281a409ca"
    sha256 cellar: :any,                 arm64_sequoia: "475ec1a589ff0454a78f47daa221cde466f658eb94b0317a9b136f990fd17f1e"
    sha256 cellar: :any,                 arm64_sonoma:  "e9013365ba0618e900fd66bc89b9a44f0ada967d149edd8a5286ac2d8bc75b6d"
    sha256 cellar: :any,                 sonoma:        "be89f71b83662d272b2fe11a1cda6a2d666839014aea1f0cd97b09e006b72f37"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "325eeaf4fd666c7208fc4eb2c0094c9842331144663ef03200ebd8d8f783511c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bdca044ed55118e25a83d39bc6e463f614fffc7f2aff84d484855eaa8714b36b"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "libmodbus"

  # fix missing INT_MAX/INT_MIN definitions, upstream pr ref: https://github.com/epsilonrt/mbpoll/pull/105
  patch do
    url "https://github.com/epsilonrt/mbpoll/commit/8a8bd34d803ef8f4daa5aad13eabbe838e2f3fad.patch?full_index=1"
    sha256 "9c663ed9c66e6c62423957a2f19f0916d3ff577433f06f088b721db62c6c080b"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    # NOTE: using "1.0-0" and not "1.5.2"
    # upstream fix pr: https://github.com/epsilonrt/mbpoll/pull/58
    assert_match "1.0-0", shell_output("#{bin}/mbpoll -V")

    assert_match "Connection failed", shell_output("#{bin}/mbpoll -1 -o 0.01 -q -m tcp invalid.host 2>&1", 1)
  end
end
