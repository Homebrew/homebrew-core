class Qjackctl < Formula
  desc "Simple Qt application to control the JACK sound server daemon"
  homepage "https://qjackctl.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/qjackctl/qjackctl/1.0.2/qjackctl-1.0.2.tar.gz"
  sha256 "0c67eec8fa428b10ff7401402a5cf37fc5e27fa6b64087eb77dba385b6c9f017"
  license "GPL-2.0-or-later"
  head "https://git.code.sf.net/p/qjackctl/code.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{url=.*?/qjackctl[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_sonoma:  "6fff2b531fbdcc8f712eb2bae1c0898954b21426d7d0f0cba35fe7acdcb6a672"
    sha256 arm64_ventura: "0c52ae503c36dd087c89defa1f0f1eabf1677180a3537f3959e283fbe05f0083"
    sha256 sonoma:        "16f0eb94ba521ad8c09055ddae0f6d599e47547a4de3ed46ea0430481be0819e"
    sha256 ventura:       "77b110128570b562a3c37aea275a678c8b217103b39715de814246ea4fa33d29"
    sha256 x86_64_linux:  "4cf00944bd91d8dbb24528043a2122583c80d14b6209bd6c0aaa806a6add776b"
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
