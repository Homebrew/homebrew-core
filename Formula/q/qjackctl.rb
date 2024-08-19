class Qjackctl < Formula
  desc "Simple Qt application to control the JACK sound server daemon"
  homepage "https://qjackctl.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/qjackctl/qjackctl/1.0.1/qjackctl-1.0.1.tar.gz"
  sha256 "b955b00e72272da027f8fffa02822529d6d993b3c4782a764cda9c4c2f27c13d"
  license "GPL-2.0-or-later"
  head "https://git.code.sf.net/p/qjackctl/code.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{url=.*?/qjackctl[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_sonoma:   "d2b4f3d2fc1f20737038f46923b69d58430311f70625dbe5cdc5d0560539849e"
    sha256 arm64_ventura:  "4f04e90f76523e8414a5b244312cdd904dc34c9093e1772a77ce399c97d39d3f"
    sha256 arm64_monterey: "266768bb56752ce2f4fe00c1b1c435d65862f5c54488fb46864cea7ec1bfce59"
    sha256 sonoma:         "5a027183f6de199940c5249edf44987af3d99bd7e891f9e99cdc0b47ddb7cea1"
    sha256 ventura:        "40f0c941db668440ff18b89a135ce774f6ce46f3d8ea66a609a6983f6dd3878f"
    sha256 monterey:       "89714da9564ac51f1f8b34781a6a42eb52f4b5f75ce2116fa769b1e75a5918f2"
    sha256 x86_64_linux:   "b67771519473cf1c45880a6724d507dbbe2849599b92f4f744d952dca879aa28"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "jack"
  depends_on "qt"

  on_linux do
    depends_on "alsa-lib"
  end

  fails_with gcc: "5"

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
    # Set QT_QPA_PLATFORM to minimal to avoid error "qt.qpa.xcb: could not connect to display"
    ENV["QT_QPA_PLATFORM"] = "minimal" if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    assert_match version.to_s, shell_output("#{bin}/qjackctl --version 2>&1")
  end
end
