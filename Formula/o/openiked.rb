class Openiked < Formula
  desc "IKEv2 daemon - portable version of OpenBSD iked"
  homepage "https://openiked.org"
  url "https://cdn.openbsd.org/pub/OpenBSD/OpenIKED/openiked-7.2.tar.gz"
  mirror "https://mirror.edgecast.com/pub/OpenBSD/OpenIKED/openiked-7.2.tar.gz"
  sha256 "55dc270bc40a121f855d949a25a5ffaeb11e7607e8198ec52160ef54b6946845"
  license "ISC"
  revision 1

  livecheck do
    url "https://cdn.openbsd.org/pub/OpenBSD/OpenIKED/"
    regex(/href=.*?openiked[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256                               arm64_ventura:  "1506a1268e445795d9391cbb4076543537f58ea6283e9b984e7208a0d757a123"
    sha256                               arm64_monterey: "febbe8eb3444ad1b3f87022fab852b9e8d3c258b7f7a1dc7d8318061090d1979"
    sha256                               arm64_big_sur:  "bd3fa710e1533a58ff15552c940b076322b35549678d8831417fe6bde33f7bb2"
    sha256                               ventura:        "cfb9dd8d2162af79efbba3acd06bd0b69a7e23359abdc7994b3fe438952e4329"
    sha256                               monterey:       "60ab7c8c3c95cce68a4671f675896b42a5a838147ce54fef8906c7c7491e006b"
    sha256                               big_sur:        "fda3e94e6c5f0b929b8643fd42da2755be8d1bd39873dd71d13aebae245be7bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6dc8b811d18291943301c5eb5bd07dec8793675bfb66e85b729147c15db45583"
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
