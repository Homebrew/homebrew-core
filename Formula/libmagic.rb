class Libmagic < Formula
  desc "Implementation of the file(1) command"
  homepage "https://www.darwinsys.com/file/"
  url "ftp://ftp.astron.com/pub/file/file-5.29.tar.gz"
  mirror "https://fossies.org/linux/misc/file-5.29.tar.gz"
  sha256 "ea661277cd39bf8f063d3a83ee875432cc3680494169f952787e002bdd3884c0"

  bottle do
    sha256 "146769301626e0dd89c9a43ee792d9bb6e12141934282cdb079a97894a7fa5e9" => :sierra
    sha256 "f34471287b07b123d823fa83b3a7367c46547544ec697b1b73bd8b9431159a4c" => :el_capitan
    sha256 "54a619ed0c36e8003cde613d05d5ba3d823bf8e53f475e053264efb5d8b63765" => :yosemite
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
