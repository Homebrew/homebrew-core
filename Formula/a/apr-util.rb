class AprUtil < Formula
  desc "Companion library to apr, the Apache Portable Runtime library"
  homepage "https://apr.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=apr/apr-util-1.6.3.tar.bz2"
  mirror "https://archive.apache.org/dist/apr/apr-util-1.6.3.tar.bz2"
  sha256 "a41076e3710746326c3945042994ad9a4fcac0ce0277dd8fea076fec3c9772b5"
  license "Apache-2.0"
  revision 1

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 arm64_tahoe:    "c1b6ca1239679046b74a5ea73032f87a83cbc9c503455a0cf3bc12a54777a03d"
    sha256 arm64_sequoia:  "6d3282873dffcfed602c5cfb7eb5ddad4b7115aaa954e191dfd4b733a58ef43e"
    sha256 arm64_sonoma:   "e21a775a4cd6e721ad4f09cd7ed0355b5a1181ca8ad6834911a045c8f076eb01"
    sha256 arm64_ventura:  "cb73075171b2079d2b8e8028f42766dffa5db08882261c3f5aff59d8eb9638a9"
    sha256 arm64_monterey: "e4a7a42c82ae44bb192b2f718af4ced48d34560325b63d5c653a5c569edf759f"
    sha256 arm64_big_sur:  "689fd5b76d98449ae31a78ac1380412248ce10a91409c7c1e16d4e2efbd2a32e"
    sha256 sonoma:         "a59301c0e98b321c57fc3c8fac679a1e1bcdd5bce470fef60adc240f9c575674"
    sha256 ventura:        "127d4d4523d49a73e7dbf610f3e439ac2051a383edbf28cc18438faf78945ef0"
    sha256 monterey:       "1d6b4a8fed8cbec1e7056432a378b27455454f7b69de61a227d452a7b4671551"
    sha256 big_sur:        "92bfab4310f0b384081f1997054f207e0d03c97e067407a328e19148a0132375"
    sha256 arm64_linux:    "830c11d6eb7e0d08d27adeac35c24865e6a49c1bef237b6dc704ca4057062a7d"
    sha256 x86_64_linux:   "5ad68f7525d3368b7e1fae3157c0338fffad2d33a907413c87ce8728c2e19378"
  end

  keg_only :shadowed_by_macos, "Apple's CLT provides apr (but not apr-util)"

  depends_on "apr"
  depends_on "openssl@3"

  uses_from_macos "expat"
  uses_from_macos "libxcrypt"
  uses_from_macos "sqlite"

  on_linux do
    depends_on "mawk"
    depends_on "unixodbc"
  end

  def install
    system "./configure", *std_configure_args,
                          "--with-apr=#{Formula["apr"].opt_prefix}",
                          "--with-crypto",
                          "--with-openssl=#{Formula["openssl@3"].opt_prefix}",
                          "--without-pgsql"

    system "make"
    system "make", "install"

    # Install symlinks so that linkage doesn't break for reverse dependencies.
    # This should be removed on the next ABI breaking update.
    (libexec/"lib").install_symlink Dir["#{lib}/#{shared_library("*")}"]

    rm Dir[lib/"**/*.{la,exp}"]

    # No need for this to point to the versioned path.
    inreplace bin/"apu-#{version.major}-config", prefix, opt_prefix
  end

  test do
    assert_match opt_prefix.to_s, shell_output("#{bin}/apu-#{version.major}-config --prefix")
  end
end
