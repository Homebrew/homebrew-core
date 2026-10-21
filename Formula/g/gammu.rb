class Gammu < Formula
  desc "Command-line utility to control a phone"
  homepage "https://wammu.eu/gammu/"
  url "https://github.com/gammu/gammu/releases/download/1.45.1/Gammu-1.45.1.tar.gz"
  sha256 "09c32e0573db6c26b23c185ce0e5600677bd57bf98cf7ec69557e24a5cad7c40"
  license "GPL-2.0-or-later"
  head "https://github.com/gammu/gammu.git", branch: "master"

  bottle do
    sha256 arm64_golden_gate: "35d4acffc29b3ee3ffe6be4ab7cb6048e644a95763db37c327fdd605f6bee502"
    sha256 arm64_tahoe:       "9f2e763c4563c3a8b3d80970ef4e80c0a529a795788e39b06aaf5ca5b0dbfb70"
    sha256 arm64_sequoia:     "2f7277db3fd8f6004e0943ff77cd28956e5da7d4601b2bcea872cfed20ee2db0"
    sha256 arm64_linux:       "4cfbcee77564701ae9655cc324185184e6457d35059694ad249289ef6cc738c9"
    sha256 x86_64_linux:      "01917cac3b76d618dfd98a33f14a43e6d7d58ca169b749830cc2dad6cc9d102d"
  end

  depends_on "cmake" => :build

  depends_on "glib"

  on_macos do
    depends_on "gettext"
  end

  def install
    args = %W[
      -DBASH_COMPLETION_COMPLETIONSDIR=#{bash_completion}
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DWITH_Postgres=OFF
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"gammu", "--help"
  end
end
