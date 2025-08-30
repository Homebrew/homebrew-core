class OsspUuid < Formula
  desc "ISO-C API and CLI for generating UUIDs"
  homepage "https://git.sr.ht/~nabijaczleweli/ossp-uuid"
  url "https://git.sr.ht/~nabijaczleweli/ossp-uuid/archive/UUID_1_6_5.tar.gz"
  sha256 "197587934c6c85f6802365f5000eb542b4858acf6d58a93e75c7616c06d89dbf"
  license "BSD-1-Clause"

  livecheck do
    url :stable
    regex(/^UUID[._-]v?(\d+(?:[._]\d+)+)$/i)
    strategy :git do |tags, regex|
      tags.map { |tag| tag[regex, 1]&.tr("_", ".") }
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "54fe9ac592343b06d7ce62e286cf0afd06f90be6c9aebd779102403c51cd55ea"
    sha256 cellar: :any,                 arm64_sonoma:   "54b71284924df66d47fb0544f6a20c058e4118b0b6c7e4e25938a9e5db0b19f9"
    sha256 cellar: :any,                 arm64_ventura:  "3285f1a05e275068e1c5aee7036066c23859b53f56fff5795e08cf18cd6d4d75"
    sha256 cellar: :any,                 arm64_monterey: "09aff0ba17ad31b748e80e71d1138b457798a9bff6cb101750343b47f9db06d9"
    sha256 cellar: :any,                 arm64_big_sur:  "e0ce19ff28fdcdd2f39dfc8706124f4d9b75e5fc3865ba2fc17c1de2fb9b9f29"
    sha256 cellar: :any,                 sonoma:         "f1055cbbeef1485ae007d2a71818cfb7f2a3b1e4a4cb6e7d69f7bf79796dfaf5"
    sha256 cellar: :any,                 ventura:        "be5ba7669ab915635b5d56d6bccfbaf39f6706acb66329e1ad194177eae2cb5b"
    sha256 cellar: :any,                 monterey:       "46c913bd5d404f0ea9dc7467a072ddf3d29f64dff75bfa4527476a5ed67ffd87"
    sha256 cellar: :any,                 big_sur:        "610cf9d70494965c79a4f1fc39a7b9e2854efa0e69fdd152cf54485e2d6b7958"
    sha256 cellar: :any,                 catalina:       "fd727fb38c48eda8d6bcb36be17e281b2152a54144298d39cab50ec7743e8a95"
    sha256 cellar: :any,                 mojave:         "a6852dac557e1b804a240b4f558d9b2e262adebb64424061f2ee8002a3d19476"
    sha256 cellar: :any,                 high_sierra:    "a04214b22c58bd5167778925cb9e55b98f28330bcc6c6a37929e6085ea3a0162"
    sha256 cellar: :any,                 sierra:         "3c15cd0e25e3039e0d05b94d14b714745cec3033863d5dc7a6d9ddd7cacc1c71"
    sha256 cellar: :any,                 el_capitan:     "ac4456fc1c29db7e0d565ebdd392cf827be315b52c9eb3abcd113c4c7b981f25"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "d085b0474a2dce5f3e7c587c3fdce4c41a1ae312c5f75657494f69dab899bd8f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ec70863fae3001fc9281f76cef9ac231bd6dbb957c6382457a5848312ee1f1b0"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  depends_on "libmd"

  on_linux do
    conflicts_with "util-linux", because: "both install `uuid.3` file"
  end

  def install
    system "autoreconf", "--force", "--install", "--verbose"

    args = %W[
      --includedir=#{include}/ossp
      --without-perl
    ]
    # Help old config scripts identify arm64 linux
    args << "--build=aarch64-unknown-linux-gnu" if OS.linux? && Hardware::CPU.arm? && Hardware::CPU.is_64_bit?

    system "./configure", *args, *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/uuid-config --version")
    assert_match(/^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/, shell_output("#{bin}/uuid -n 1"))
  end
end
