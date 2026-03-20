class Qjackctl < Formula
  desc "Simple Qt application to control the JACK sound server daemon"
  homepage "https://qjackctl.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/qjackctl/qjackctl/1.0.5/qjackctl-1.0.5.tar.gz"
  sha256 "ce6056dd17fd5c1e8cca928754357f3cc6a6ff8464c9e05b07f8011b2597ec61"
  license "GPL-2.0-or-later"
  head "https://git.code.sf.net/p/qjackctl/code.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{url=.*?/qjackctl[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_tahoe:   "920a75fe7293a69246900ad32076b30664108d832355a537f03ad4b9dffc74c0"
    sha256 arm64_sequoia: "a0a31424e3de8d51f1dee15e5e92fea5a03d453731042707943758fba2d589a4"
    sha256 arm64_sonoma:  "c8d960f0ba5c1de5ecef6fc877570098ec77125c603a1d3247ce48fc2aab2598"
    sha256 sonoma:        "1b68ec180377ed8a00935ef037e7ff50a70738f03f5a5c46ccb4e4bbf8bf1fe5"
    sha256 arm64_linux:   "dca44237f1bae122b317740ec831d3d68e132415b53cfd10c62db236117315f6"
    sha256 x86_64_linux:  "06145fdf9dc0b34aaa2aac747efe52df93590b72f9916ee15fcf14b7c75797e8"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "qttools" => :build
  depends_on "jack"
  depends_on "qtbase"
  depends_on "qtsvg"

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
