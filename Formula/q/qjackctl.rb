class Qjackctl < Formula
  desc "Simple Qt application to control the JACK sound server daemon"
  homepage "https://qjackctl.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/qjackctl/qjackctl/0.9.13/qjackctl-0.9.13.tar.gz"
  sha256 "ebbc3774b8c2db6ded3c5553939c65e095ce796750d53ee1a299c113a33564b3"
  license "GPL-2.0-or-later"
  head "https://git.code.sf.net/p/qjackctl/code.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{url=.*?/qjackctl[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_sonoma:   "9cff10f30ccb748d29b26363675e95a492fd4f0a2bce3ac65ed00197b2de40b5"
    sha256 arm64_ventura:  "502b9789aec98772645b2135f1b6b7a82638a8eb6d34941430128c0b742c38d6"
    sha256 arm64_monterey: "afa404749633aa15fcc566f15f5c136d5dc2401ebafefd899ab43485657fed9a"
    sha256 sonoma:         "a989646c2ec15c84fd241a1a65f5246ee0d5405a020b513f33bc1f586c789230"
    sha256 ventura:        "6272ec9559af08188886c29e4878de9c1107617fd816c0a77701554b87a7b79d"
    sha256 monterey:       "a256b99389b94304f68f94bf2896d70f66eb5dc74027e457cc02451100241f84"
    sha256 x86_64_linux:   "0e8f5b3601a85196443086fd4c86fb2aacd75180a44f09f51901c06a0544356d"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
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
