class Qjackctl < Formula
  desc "Simple Qt application to control the JACK sound server daemon"
  homepage "https://qjackctl.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/qjackctl/qjackctl/1.0.4/qjackctl-1.0.4.tar.gz"
  sha256 "e3eb6f989d947dcd97b4fe774294347106a0a6829c0480a965393ebca97514ae"
  license "GPL-2.0-or-later"
  head "https://git.code.sf.net/p/qjackctl/code.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{url=.*?/qjackctl[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "b6b29448edf9d0cb0e99406289f410a3a8adc6c288f9092777be85958b3434b7"
    sha256 arm64_sequoia: "dfc335c469d0b4f65ae054343c453377b0db2e8e8171eec52b0fe244fc615ad9"
    sha256 arm64_sonoma:  "c3c3215ed601d2689849cdb23adc9a50d4b50203a0a6f336ca55bea90e6610b0"
    sha256 sonoma:        "8f8e32f847d7118c7c15fae9eeb551982a8ad74b7f5ea3d280944b72bbb51ad2"
    sha256 arm64_linux:   "bf7cf0202b94f8c8324c2f73cfc39c29c38c15ddb8dad9038365e87c42ce8346"
    sha256 x86_64_linux:  "dc312c775a04b6226512ff0867dc3365e3a9db3d3b06fd88ae40170c73421aa9"
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
