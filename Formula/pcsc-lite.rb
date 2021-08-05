class PcscLite < Formula
  desc "Middleware to access a smart card using SCard API"
  homepage "https://pcsclite.apdu.fr/"
  url "https://pcsclite.apdu.fr/files/pcsc-lite-1.9.2.tar.bz2"
  sha256 "b267098e6d822903fba23b6183c17fd3678018b8544d1510bb7f2be802906b42"
  license all_of: ["BSD-3-Clause", "GPL-3.0-or-later", "ISC"]

  livecheck do
    url "https://pcsclite.apdu.fr/files/"
    regex(/href=.*?pcsc-lite[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "a90b84c64a9da83449d1c5a7f3a8ebf98efd0a4bf05c3f413863c64c70833fe4"
    sha256 cellar: :any,                 big_sur:       "7f4cd20b44f103bce6a0b890becf77d3f84d9438968121962ade46d3fb05a818"
    sha256 cellar: :any,                 catalina:      "b096ea000476d41b728621df1629d8ff398f3e8f4a7f8272f233d74fafee068f"
    sha256 cellar: :any,                 mojave:        "d7708933123d6ee85063eb1cabb0e8c7db2c418158aa3da36520b22caa861724"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dc7720e916490b822835e5ef993ba4374b0d6f327795531eebc7311e554a41a9"
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

    on_linux do
      args << "--disable-udev"
    end

    system "./configure", *args
    system "make", "install"
  end

  test do
    system sbin/"pcscd", "--version"
  end
end
