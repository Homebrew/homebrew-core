class Qjackctl < Formula
  desc "Simple Qt application to control the JACK sound server daemon"
  homepage "https://qjackctl.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/qjackctl/qjackctl/1.0.4/qjackctl-1.0.4.tar.gz"
  sha256 "e3eb6f989d947dcd97b4fe774294347106a0a6829c0480a965393ebca97514ae"
  license "GPL-2.0-or-later"
  head "https://git.code.sf.net/p/qjackctl/code.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{url=.*?/qjackctl[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_sonoma:  "6bc46dab635d6d238075bd40608f12f0e2b91da3ea35fcd0f111c950e236819d"
    sha256 arm64_ventura: "d4e7befa66d433bda2982d1b2298cd7b031190e2f5341afb82df72aa57bdc126"
    sha256 sonoma:        "4dcb152f927b45874dcb902c7fa5657c2699511c52a0157cf2f2852d82204aa7"
    sha256 ventura:       "833e34b3aa6e9a987da110efc4a1e28ab9e9ce37e11d50fa6d17df3aa9f27358"
    sha256 x86_64_linux:  "2d0274d62dd74b8cdb1edb6dff3137b21a48d73de5258b2e3dc3a714ed8eca40"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "jack"
  depends_on "qt"

  on_linux do
    depends_on "alsa-lib"
  end

  def install
    args = %w[
      -DCONFIG_DBUS=OFF
      -DCONFIG_PORTAUDIO=OFF
      -DCONFIG_XUNIQUE=OFF
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    if OS.mac?
      prefix.install bin/"qjackctl.app"
      bin.install_symlink prefix/"qjackctl.app/Contents/MacOS/qjackctl"
    end
  end

  test do
    # Detected locale "C" with character encoding "US-ASCII", which is not UTF-8.
    ENV["LC_ALL"] = "en_US.UTF-8"

    # Set QT_QPA_PLATFORM to minimal to avoid error "qt.qpa.xcb: could not connect to display"
    ENV["QT_QPA_PLATFORM"] = "minimal" if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    assert_match version.to_s, shell_output("#{bin}/qjackctl --version 2>&1", 1)
  end
end
