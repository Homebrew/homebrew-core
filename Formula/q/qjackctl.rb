class Qjackctl < Formula
  desc "Simple Qt application to control the JACK sound server daemon"
  homepage "https://qjackctl.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/qjackctl/qjackctl/0.9.12/qjackctl-0.9.12.tar.gz"
  sha256 "08ac61980820e1aa9b7e728e04d8ca1d463b50861e3b572c6b46127fb9836540"
  license "GPL-2.0-or-later"
  head "https://git.code.sf.net/p/qjackctl/code.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{url=.*?/qjackctl[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_ventura:  "77a62497e3b98b6f5de4f71a19446ad1b7f7fe4ffa319777e553e3eaea2cc3d7"
    sha256 arm64_monterey: "5f0e0fecdaef3fda61739f1a58ef7f508829092fc4cedc5ebbe34f708d9460de"
    sha256 arm64_big_sur:  "f65afa15dec149b2a0f7faf3c9f1903d8a832382f0c7aaced0d31a7ad12f4769"
    sha256 ventura:        "89d072b5c72578d0d1c0077ebcb6eb317a7105c61e149ab7d744f155f4bdadc1"
    sha256 monterey:       "07c874746f3209637a7e50e377c49441e6809cadafd8c9c81027c44a55b797f8"
    sha256 big_sur:        "68bb4d82aed4f5912fdb14be4d0ba63555e89c65675dc8a25fd1e52c44e1c273"
    sha256 x86_64_linux:   "26f28872e134da8aae759c859edc3f6d66cc667fe59a5253025a01dd90e0cfe9"
  end

  depends_on "cmake" => :build
  depends_on "jack"
  depends_on "qt"

  fails_with gcc: "5"

  def install
    args = std_cmake_args + %w[
      -DCONFIG_DBUS=OFF
      -DCONFIG_PORTAUDIO=OFF
      -DCONFIG_XUNIQUE=OFF
    ]

    system "cmake", *args
    system "cmake", "--build", "."
    system "cmake", "--install", "."

    if OS.mac?
      prefix.install bin/"qjackctl.app"
      bin.install_symlink prefix/"qjackctl.app/Contents/MacOS/qjackctl"
    end
  end

  test do
    # Set QT_QPA_PLATFORM to minimal to avoid error "qt.qpa.xcb: could not connect to display"
    ENV["QT_QPA_PLATFORM"] = "minimal" if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    assert_match version.to_s, shell_output("#{bin}/qjackctl --version 2>&1")
  end
end
