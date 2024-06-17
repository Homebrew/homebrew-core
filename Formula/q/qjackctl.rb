class Qjackctl < Formula
  desc "Simple Qt application to control the JACK sound server daemon"
  homepage "https://qjackctl.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/qjackctl/qjackctl/0.9.91/qjackctl-0.9.91.tar.gz"
  sha256 "4d700d24862093f2f868857ecef6a127bbbeb81704c408ca6d5a69c80652c55f"
  license "GPL-2.0-or-later"
  head "https://git.code.sf.net/p/qjackctl/code.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{url=.*?/qjackctl[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_sonoma:   "2259f8733d7ad6d3f7c2dd6315996e2c22d78366d96de73b82de3e1829802b56"
    sha256 arm64_ventura:  "719d3cf7f639f6b04b4e797c902fcc6c5b01c039be21a5b9297210f01075c6bb"
    sha256 arm64_monterey: "66e32203b605cf8f8bf1e540aa87a1db88f7bfdeb403a599afdffa917b57c0b2"
    sha256 sonoma:         "a2f7566f12abe09a1cc87d7ac358be19dab130f9560a88af8401991e065cff68"
    sha256 ventura:        "1e946d8830de71ad8d15db44aa5ceafe449152d1d1bceebc26ff1c8be4d64242"
    sha256 monterey:       "bb2400a3bbe9788d84e13239321b7b5e7b4e69f6071f333890076465f5c226cb"
    sha256 x86_64_linux:   "c733bb060b1a1bb5e428d92ad5e7c38ac481729128e388701fdbce5eb42f692b"
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
