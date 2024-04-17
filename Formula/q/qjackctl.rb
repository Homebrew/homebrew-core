class Qjackctl < Formula
  desc "Simple Qt application to control the JACK sound server daemon"
  homepage "https://qjackctl.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/qjackctl/qjackctl/0.9.90/qjackctl-0.9.90.tar.gz"
  sha256 "e537f496a9c67aef94c48fd3c607d73977dfbb090bf44f41529de78e0ef5117d"
  license "GPL-2.0-or-later"
  head "https://git.code.sf.net/p/qjackctl/code.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{url=.*?/qjackctl[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_sonoma:   "5a6cf19ab7193ce8ec3c758157e4397d0b7a6e29b74fe5031910cc81b0a4d98c"
    sha256 arm64_ventura:  "c3dff58deddfac1be25ce953eeb05e548aef027adbf667df63ec6aea048c8f4c"
    sha256 arm64_monterey: "136ee27ad974c744c0a489bfc677a7a12929149ec0d77beda842d32a8615fefa"
    sha256 sonoma:         "b7c3ab341c05ad0e94ede6f5d76481d1eb60844c7c0ac9210a29f2ae9adf689f"
    sha256 ventura:        "a77324070160c8cfe01c7af9c913ace84c1b58e58e6ad79063373231bd7c6ea2"
    sha256 monterey:       "bc42f826797c25bd9f85c27b877016786b0a252f4ea4a7a397ae4c149de78dbb"
    sha256 x86_64_linux:   "5136d9d968cee2dbf3b87bac9146bc82ffdef3e4cd4610150cedd7da57357569"
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
