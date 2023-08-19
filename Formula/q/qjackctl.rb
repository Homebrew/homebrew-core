class Qjackctl < Formula
  desc "Simple Qt application to control the JACK sound server daemon"
  homepage "https://qjackctl.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/qjackctl/qjackctl/0.9.11/qjackctl-0.9.11.tar.gz"
  sha256 "9ebe21b883f0b8d00ba9d52f81efa22c198c6f53d6cc605561d2e967589190f7"
  license "GPL-2.0-or-later"
  head "https://git.code.sf.net/p/qjackctl/code.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{url=.*?/qjackctl[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_ventura:  "baa20bc782384ad46dced4133608eb010e0e6f322cead96d71ab7ee6583f6e75"
    sha256 arm64_monterey: "038074404a2edef22d820152355e4449ef63def322496bd692058507c521edbe"
    sha256 arm64_big_sur:  "2d4e75a5685e061cd1913d3289b548c82c39f51f516b373e7449bc4193c31778"
    sha256 ventura:        "ff578eaeeada8418a8f24703e64c0c8fba134f5d56505f741b21beb1d1078d33"
    sha256 monterey:       "50709a8c680c4651cd2e954c31d6df761a457274a63197200c30f44b0994c0a6"
    sha256 big_sur:        "5d77bf148b6805bfa6b96f0f4636805fc43c3476dd8b3e14e85e8b0d6f2a205b"
    sha256 x86_64_linux:   "884c720004b7d11206d5c50bddf697c21b9b8c0fc3b47b0c5a8796e2a15582da"
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
