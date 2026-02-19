class Libdsk < Formula
  desc "Library for accessing discs and disc image files"
  homepage "https://www.seasip.info/Unix/LibDsk/"
  url "https://www.seasip.info/Unix/LibDsk/libdsk-1.4.2.tar.gz"
  sha256 "71eda9d0e33ab580cea1bb507467877d33d887cea6ec042b8d969004db89901a"
  license "LGPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/Stable version.*?href=.*?libdsk[._-]v?(\d+(?:\.\d+)+)\.t/im)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "feb56e14f0d05e880c42e25c4780cba7eb930b9e1aa4a313045accd8abdf4e49"
    sha256 cellar: :any,                 arm64_sequoia: "1d621ecbf36e2c65f1c29143004543db6864aa372b487fad25587e36ce42bbf9"
    sha256 cellar: :any,                 arm64_sonoma:  "4cb16e1f82fdffbf20ecd541d2bfb9cccc58a47c8b1342293aace84fe2a19ec5"
    sha256 cellar: :any,                 sonoma:        "c747e86cb14f14a46f3cc70433d08d9825d5b5c13b179457a53c136960b3cbf0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ff17529b023259b9a186572ad5a7ebef05b0b69854816925bd050a3dbb95818d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "73e738d8f00362818ad45c1f155f52b99c97d72a2b56dae78390ff01f702bf99"
  end

  on_linux do
    depends_on "zlib-ng-compat"
  end

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/libtool/configure-big_sur.diff"
    sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
  end

  def install
    # Avoid lyx dependency
    inreplace "Makefile.in", "SUBDIRS = . include lib tools man doc",
                             "SUBDIRS = . include lib tools man"

    args = []
    if OS.linux?
      # Help old config scripts identify arm64 linux
      args << "--build=aarch64-unknown-linux-gnu" if Hardware::CPU.arm? && Hardware::CPU.is_64_bit?
      # Workaround for undefined reference to `major'. Remove in the next release
      ENV.append "CFLAGS", "-include sys/sysmacros.h"
      odie "Remove sys/sysmacros.h workaround!" if version >= "1.5"
    end

    system "./configure", *args, *std_configure_args
    system "make"
    system "make", "check"
    system "make", "install"
    doc.install Dir["doc/*.{html,pdf,sample,txt}"]
  end

  test do
    assert_equal "#{name} version #{version}\n", shell_output("#{bin}/dskutil --version")
  end
end
