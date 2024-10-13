class Openiked < Formula
  desc "IKEv2 daemon - portable version of OpenBSD iked"
  homepage "https://openiked.org"
  url "https://cdn.openbsd.org/pub/OpenBSD/OpenIKED/openiked-7.3.tar.gz"
  mirror "https://mirror.edgecast.com/pub/OpenBSD/OpenIKED/openiked-7.3.tar.gz"
  sha256 "9a04d513a81f9d5a873a0bd9992067a55796812674c9a96791b3adc6a63e6347"
  license "ISC"

  livecheck do
    url "https://cdn.openbsd.org/pub/OpenBSD/OpenIKED/"
    regex(/href=.*?openiked[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256                               arm64_sequoia:  "7c229f067ee01e9d9c836b52370695f08b8f382a3fb7620ec95051de872f715e"
    sha256                               arm64_sonoma:   "8b138fbe3eb1179b35223a7f54d6ae54177393d8b743723632f6b4a8beff019e"
    sha256                               arm64_ventura:  "533d59a19657c6cadb5b4347c3e40016cbc0bd269ffb84d1605c7bce6801f66f"
    sha256                               arm64_monterey: "d718da1d03105aed43bd7ec97e5f2b60f71577296a555bb7f3278b070f04030c"
    sha256                               sonoma:         "78e7655a4f26f4e74e5fc81a22a8b32d8d4ec19d32645529bbc42a51fd801f16"
    sha256                               ventura:        "9d22679a1192e1aabd262ea41dedb4236ea62ff133faab3602bfa3de4b5b5c9e"
    sha256                               monterey:       "dbba1126cc4b34ed420abac2fe3f2a0602c37fd856572456c208562e07d49df2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dec0feb61a323ed45258f074cfd68cb7f0f4a0746bfbb59b754c9d5b21675e60"
  end

  depends_on "cmake" => :build
  depends_on "libevent"
  depends_on "openssl@3"

  uses_from_macos "bison"

  def install
    system "cmake", "-S", ".", "-B", "build",
                         "-DHOMEBREW=true",
                         "-DCMAKE_INSTALL_SYSCONFDIR=#{etc}",
                         "-DCMAKE_INSTALL_MANDIR=#{man}",
                         *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    libexec.install "build/regress/dh/dhtest"
  end

  service do
    run opt_sbin/"iked"
    keep_alive true
    require_root true
    working_dir etc
  end

  def caveats
    <<~EOS
      config file can be found here:
        #{etc}/iked.conf

      necessary files for configuration can be found here:
        #{etc}/iked/
    EOS
  end

  test do
    system sbin/"iked", "-V"
    system libexec/"dhtest"
  end
end
