class Gammu < Formula
  desc "Command-line utility to control a phone"
  homepage "https://wammu.eu/gammu/"
  url "https://github.com/gammu/gammu/releases/download/1.43.2/Gammu-1.43.2.tar.gz"
  sha256 "bd521c0483a52808abf885cf0dd9f42036354a5f94518ffe064cb9e7ef23fd02"
  license "GPL-2.0-or-later"
  head "https://github.com/gammu/gammu.git", branch: "master"

  bottle do
    sha256 arm64_tahoe:   "578f3bf4bf220f323c098361dce5fbf5dcc4a18ff2db6639f54af79d4aa21322"
    sha256 arm64_sequoia: "1666c00b3273b20c1ec8056e08761fd7ca411be25f9b9cf48f52688825320693"
    sha256 arm64_sonoma:  "7ec4259bb5a1037c69afea1b277862bb763eab63291e02402d6b110b2b7b542c"
    sha256 sonoma:        "13426d12478760d235564cba4f7d2712df2e88f1be47f00ad11e72e74177613a"
    sha256 arm64_linux:   "d1b8ba528cf6242e9873c95d049ba4e5feb0f71d2bee76337cfd886c5023b912"
    sha256 x86_64_linux:  "4ab3b6112226e0d666033b9d0ae877e99ec4417b0ebea3f5f51cbe61ba00783b"
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
