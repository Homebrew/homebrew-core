class PcscLite < Formula
  desc "Middleware to access a smart card using SCard API"
  homepage "https://pcsclite.apdu.fr/"
  url "https://pcsclite.apdu.fr/files/pcsc-lite-1.9.5.tar.bz2"
  sha256 "9ee3f9b333537562177893559ad4f7b8d5c23ebe828eef53056c02db14049d08"
  license all_of: ["BSD-3-Clause", "GPL-3.0-or-later", "ISC"]

  livecheck do
    url "https://pcsclite.apdu.fr/files/"
    regex(/href=.*?pcsc-lite[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "58d2948f8920bcb6c459408452b9086da9e26802c54ad75130f5c968b8d563b7"
    sha256 cellar: :any,                 arm64_big_sur:  "d8bd2a6a9c6006f168138cef6df3b5903cb899e0bb8a657ecfd70bc05de82073"
    sha256 cellar: :any,                 monterey:       "76a55f31e459abbe18ed16fd4f103ae7ee11bfeea91b35f28aec91160bbf3c61"
    sha256 cellar: :any,                 big_sur:        "752070630d5c324beb9366f08d5b18f680a4336ed0e77c4aab39d754ce20849f"
    sha256 cellar: :any,                 catalina:       "ce0f31bd6c00894f530ef0b9496f309a75e79df3b89ba97fbf78d57c7c43a5fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0e27431f84b844674ec8442ec3bd751fdd169a4d5a30778382c6d5dbb17287d3"
  end

  keg_only :shadowed_by_macos, "macOS provides PCSC.framework"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "libusb"
  end

  def install
    args = %W[--disable-dependency-tracking
              --disable-silent-rules
              --prefix=#{prefix}
              --sysconfdir=#{etc}
              --disable-libsystemd]

    args << "--disable-udev" if OS.linux?

    system "./configure", *args
    system "make", "install"
  end

  test do
    system sbin/"pcscd", "--version"
  end
end
