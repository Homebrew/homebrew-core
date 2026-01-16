class Fastjar < Formula
  desc "Implementation of Sun's jar tool"
  homepage "https://savannah.nongnu.org/projects/fastjar"
  url "https://download.savannah.nongnu.org/releases/fastjar/fastjar-0.98.tar.gz"
  sha256 "f156abc5de8658f22ee8f08d7a72c88f9409ebd8c7933e9466b0842afeb2f145"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://download.savannah.nongnu.org/releases/fastjar/"
    regex(/href=.*?fastjar[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "9d3f55c3b2f687a368a908be2045d117726942501be6d90377153619675323e0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "04f3c15e78f2c33a9ef3a33561aced187286cdbbaa0ad29ace0f45f0701873fb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fc54e682bbb9eed396f0cd21f3ee472ff5473e49932cabd827a224ed01961e68"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b0499cae7fac86fbe57a98cbceffb53e2ff047cdadbcca9a103083a0cc6e9a20"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c5fa05b957bd369862d66cefb2cfe2ec5fdb86bf6ea3bcde2b8f95c1d872a293"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d9bb50e8b725164441e747625b381631edf82e0040babda6f187466295f80e3f"
    sha256 cellar: :any_skip_relocation, sonoma:         "c44006f54e184a7e71c094a93027ce855a2f352c2217b7aab2f9a2732dc4e6ea"
    sha256 cellar: :any_skip_relocation, ventura:        "9581595d1660096f047ee3c601481f6877a209c4cfd9fcfb9860fbfd79adad60"
    sha256 cellar: :any_skip_relocation, monterey:       "06ceeffa38b10f099a521d5ea3ac4dd52d6d0d5740c3fc64f6b4e8509a842cef"
    sha256 cellar: :any_skip_relocation, big_sur:        "1cbf953373b3d48accd872aa603fa66fb3b96e1ec33d4a17dfe6da2f97ad5cbb"
    sha256 cellar: :any_skip_relocation, catalina:       "ee758c76cb694c96ea30cb9e6ac204f2797c78be36610dcdf36c2a75301b5835"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "63d997e0731537e0a78b936cc74b609770452ff861403226aff0c31a5fed3436"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3ac2c41e11f88db5dd88b6cfceb7620f9f2dc26a6f7a89f224f8bd874774c6d3"
  end

  uses_from_macos "zlib"

  def install
    args = []
    # Help old config scripts identify arm64 linux
    args << "--build=aarch64-unknown-linux-gnu" if OS.linux? && Hardware::CPU.arm? && Hardware::CPU.is_64_bit?

    system "./configure", *args, *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"fastjar", "-V"
    system bin/"grepjar", "-V"
  end
end
