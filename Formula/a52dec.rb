class A52dec < Formula
  desc "Library for decoding ATSC A/52 streams (AKA 'AC-3')"
  homepage "https://liba52.sourceforge.io/"
  url "https://liba52.sourceforge.io/files/a52dec-0.7.4.tar.gz"
  sha256 "a21d724ab3b3933330194353687df82c475b5dfb997513eef4c25de6c865ec33"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://liba52.sourceforge.io/downloads.html"
    regex(/href=.*?a52dec[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b2764776e9f2cb2bd180b736a3c533835db280a8a51a34b72501e8eb0ccc3715"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8f17299eecdcf8d9a94bff90a2f48e9c2a2cffdee3b64d2633865d983171be17"
    sha256 cellar: :any,                 arm64_big_sur:  "a9a4752a7b6d4872abf06a725a44b94d1701e4621c0e4226002e371df53ff366"
    sha256 cellar: :any_skip_relocation, ventura:        "38db9ed335233c2c9f2231dec7022a3c7f5e2f145d3d21238cb934c4d8bd8b19"
    sha256 cellar: :any_skip_relocation, monterey:       "5861dcdb362d4993facf91724306204fc4775c62ab91dd340144b73897a14043"
    sha256 cellar: :any,                 big_sur:        "f5b95a6c1f7758e29cc04160d3635fce074c6c527cb3ac209877d8e4d1b4935c"
    sha256 cellar: :any,                 catalina:       "949600b627a44697bc12713538c5aed594fc8201694f5c453c8ca5f9f8cd335a"
    sha256 cellar: :any,                 mojave:         "a47f3248a481d224edcbec3e266793ff73f2e94bb607732df2166a0c6f442596"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6ba162f41f0366039355b26d363506794d39f75cbb48d8ba5879337f6c5394eb"
  end

  def install
    if OS.linux?
      # Fix error ld: imdct.lo: relocation R_X86_64_32 against `.bss' can not be
      # used when making a shared object; recompile with -fPIC
      ENV.append_to_cflags "-fPIC"
    else
      # Fixes duplicate symbols errors on arm64
      ENV.append_to_cflags "-std=gnu89"
    end

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-shared",
                          "--mandir=#{man}"
    system "make", "install"
  end

  test do
    touch testpath/"test"
    system "#{bin}/a52dec", "-o", "null", "test"
  end
end
