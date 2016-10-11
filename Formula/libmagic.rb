class Libmagic < Formula
  desc "Implementation of the file(1) command"
  homepage "https://www.darwinsys.com/file/"
  url "ftp://ftp.astron.com/pub/file/file-5.28.tar.gz"
  mirror "https://fossies.org/linux/misc/file-5.28.tar.gz"
  sha256 "0ecb5e146b8655d1fa84159a847ee619fc102575205a0ff9c6cc60fc5ee2e012"

  bottle do
    sha256 "fdfa8607a14c9dcb0686731956507e75dea169ef505d20db91c4c9233335221c" => :sierra
    sha256 "13beb0a727a18c47d10c4569772fd2077b37ed363c008faa82bc184a104c380b" => :el_capitan
    sha256 "ab633517a9be283ce7518864086d58a49a1de0926da5f65e1bbdfb5ef1d20ffb" => :yosemite
    sha256 "dfbcd1f3bee44e44bbeaa8638167359966e810f77cc6f81516776dbba979c68b" => :mavericks
  end

  option :universal

  depends_on :python => :optional

  def install
    ENV.universal_binary if build.universal?

    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--enable-fsect-man5",
                          "--enable-static"
    system "make", "install"
    (share+"misc/magic").install Dir["magic/Magdir/*"]

    if build.with? "python"
      cd "python" do
        system "python", *Language::Python.setup_install_args(prefix)
      end
    end

    # Don't dupe this system utility
    rm bin/"file"
    rm man1/"file.1"
  end
end
