class Openiked < Formula
  desc "IKEv2 daemon - portable version of OpenBSD iked"
  homepage "https://openiked.org"
  url "https://cdn.openbsd.org/pub/OpenBSD/OpenIKED/openiked-7.4.tar.gz"
  mirror "https://mirror.edgecast.com/pub/OpenBSD/OpenIKED/openiked-7.4.tar.gz"
  sha256 "19b72b48080240c3eff585f5cbcf6aa7b5734192ad8bc6677ae64a455074358a"
  license "ISC"

  livecheck do
    url "https://cdn.openbsd.org/pub/OpenBSD/OpenIKED/"
    regex(/href=.*?openiked[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256                               arm64_tahoe:   "389a513ece12bdc1424bfd0413472870c92b2591d92f4e4fa5c11fbcd97ca0ea"
    sha256                               arm64_sequoia: "6617660a67f84c4e2cc0c10be9f523df25a65ffded5fcfe49ba494557e9b1fa3"
    sha256                               arm64_sonoma:  "36a643015e36b8c418bc506f11638f8a750f09d04a47204181084f0d6d08b6a4"
    sha256                               arm64_ventura: "254aef034a2d10277cc1f8234ec8c580e40cd4f12407154a3d80860a84e6439d"
    sha256                               sonoma:        "0fc6152ed7bab0d78931c74a821e771ac561b54b8a8735885cbef6707d4f01b8"
    sha256                               ventura:       "44a959ba4bfde86399a6eaf7843efe14db59376a159f59ce5a3b4dca6a1a4290"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "96d79b9b681bb06ede6d673219578710236f9547f28892fee23f5b38e9a269c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4d42194f764e5ed3cf329655303362999b79fb5350646e57df381c1ecd419c8a"
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
