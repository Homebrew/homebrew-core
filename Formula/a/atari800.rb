class Atari800 < Formula
  desc "Atari 8-bit machine emulator"
  homepage "https://atari800.github.io/"
  license "GPL-2.0-or-later"

  stable do
    url "https://github.com/atari800/atari800/releases/download/ATARI800_5_2_0/atari800-5.2.0-src.tgz"
    sha256 "3874d02b89d83c8089f75391a4c91ecb4e94001da2020c2617be088eba1f461f"
    depends_on "sdl12-compat"
  end

  livecheck do
    url :stable
    regex(/ATARI800[._-]v?(\d+(?:[._]\d+)+)/i)
    strategy :github_latest
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "8ee4d61f11fc57cc49859acab122eb2496d334f6e9907fb7dcfd4170c4765e50"
    sha256 cellar: :any,                 arm64_sequoia: "3edaff9d17021ae93a506a9d7dbc4777a78defbae57f1048e1e4ccd3fa02fe9c"
    sha256 cellar: :any,                 arm64_sonoma:  "c185ab09782ff89d74a1224e5524e2c9135426372a685c478266b52e7b021221"
    sha256 cellar: :any,                 sonoma:        "78268655a61188a6720ce820e5eb52e6ad9fc0265d10b6d04d29a1e0305889fd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ef23849a07d7554863256ffc128394a76a4e47eda8f93628a74e828dc66bec31"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8a30c9a3ddb2ceaa47e20b75a14833b53aebdd8851d893f306c42ebd8a79fbee"
  end

  head do
    url "https://github.com/atari800/atari800.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
    depends_on "sdl2"
  end

  depends_on "libpng"

  on_linux do
    depends_on "readline"
    depends_on "zlib-ng-compat"
  end

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-sdltest",
                          "--disable-riodevice",
                          *std_configure_args.reject { |s| s["--disable-debug"] }
    system "make", "install"
  end

  test do
    assert_equal "Atari 800 Emulator, Version #{version}",
                 shell_output("#{bin}/atari800 -v", 3).strip
  end
end
