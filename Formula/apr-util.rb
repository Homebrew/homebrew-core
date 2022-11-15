class AprUtil < Formula
  desc "Companion library to apr, the Apache Portable Runtime library"
  homepage "https://apr.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=apr/apr-util-1.6.1.tar.bz2"
  mirror "https://archive.apache.org/dist/apr/apr-util-1.6.1.tar.bz2"
  sha256 "d3e12f7b6ad12687572a3a39475545a072608f4ba03a6ce8a3778f607dd0035b"
  license "Apache-2.0"
  revision 4

  bottle do
    sha256 arm64_ventura:  "534b2aef9b78f3e0c3af062fb496917b9ede4972c9e3a77675b840285cf862cd"
    sha256 arm64_monterey: "3fbbe5ef907dc7f8b259f49c0891987f088ecaa0ad0fd75d47345804ec5d2976"
    sha256 arm64_big_sur:  "72585edce1997ea0ac5be884f0fbed79f2746d3252e035ed63b1bd04ad501d94"
    sha256 ventura:        "fc26e9e914a6240452123e48d2f4bba40dcbc75dd4f797ddf0c3b91898fb4c6f"
    sha256 monterey:       "7695efa17e538d71459020c3838081629629c3c1169bd9ac166865d2bdacb213"
    sha256 big_sur:        "94a9d60abb422a135295ac6c8425af4c72a0f49f46323aa19abd4b358c03270e"
    sha256 catalina:       "8e62fdfe79eaa75a700fb97ea3264aa5bcd77dabcf526240d35537325387c353"
    sha256 x86_64_linux:   "588c3c2c34bd3078f4b181da19d07e4bb509c7cb8afbf5ab6a5d707a730dce20"
  end

  keg_only :shadowed_by_macos, "Apple's CLT provides apr (but not apr-util)"

  depends_on "apr"
  depends_on "openssl@1.1"

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
                          "--with-openssl=#{Formula["openssl@1.1"].opt_prefix}",
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
