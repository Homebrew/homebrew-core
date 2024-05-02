class Grap < Formula
  desc "Language for typesetting graphs"
  homepage "https://www.lunabase.org/~faber/Vault/software/grap/"
  url "https://www.lunabase.org/~faber/Vault/software/grap/grap-1.47.tar.gz"
  sha256 "8ff6f0dc43a660e2ac7423f161247fd0d5b765960e32d62f62ab4a404bbc11c1"
  license "BSD-2-Clause"

  livecheck do
    url :homepage
    regex(/href=.*?grap[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "fa4c99645bc2aba78314150511e6e8f51511b1d803c504c611bab1efeaa3b9e6"
    sha256 arm64_ventura:  "1b4e1d5563c5f4813db7e666d5c177b2c7e373af39a30d0e37bb24218f360858"
    sha256 arm64_monterey: "59fb2709f71268976dbae0e72fc6be33a74d98eb01bf5b4ce3b2e92dac394afd"
    sha256 sonoma:         "5e89a9a5cd6edbffd071fc48426cb480be6abd2f3927548b36a73b5f2780280e"
    sha256 ventura:        "a93d82d8acbfda916a74525809dedd5aae6874ce78855e15db511bb4040561a1"
    sha256 monterey:       "9ee0c9c01a3a3b665b678bf7f2cd7a9ebe5cc15877cb687ee5a8d12cb69c8309"
    sha256 x86_64_linux:   "ee3a10d42535ab9b8e93f7107b11d9bfd3732f92f574a0d315d1dbca3f9c48d3"
  end

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--with-example-dir=#{pkgshare}/examples"
    system "make"
    ENV.deparallelize
    system "make", "install"
  end

  test do
    (testpath/"test.d").write <<~EOS
      .G1
      54.2
      49.4
      49.2
      50.0
      48.2
      43.87
      .G2
    EOS
    system bin/"grap", testpath/"test.d"
  end
end
