class AprUtil < Formula
  desc "Companion library to apr, the Apache Portable Runtime library"
  homepage "https://apr.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=apr/apr-util-1.6.1.tar.bz2"
  mirror "https://archive.apache.org/dist/apr/apr-util-1.6.1.tar.bz2"
  sha256 "d3e12f7b6ad12687572a3a39475545a072608f4ba03a6ce8a3778f607dd0035b"
  license "Apache-2.0"
  revision 3

  bottle do
    sha256 arm64_monterey: "c47c937968e788d0a274e6bd214d20fcbfde6b5d23908b469a954d2f3e6aee59"
    sha256 arm64_big_sur:  "29ffec15c99813b879d9410e2040044b02ee8e219492d065043b4bb65cf30741"
    sha256 monterey:       "4459e0d3d15a973db35fb64b1da85d2185afc41e77d2989186db5574d3c75234"
    sha256 big_sur:        "34dd598e189eefff7e09be3ee92c17816353b02cd1eb7b333ea4c74cd6204ffd"
    sha256 catalina:       "425955a21c3fec8e78f365cd7fc4c6c4ec95d074f720a9b24e8237af90cc4dcc"
    sha256 mojave:         "b3b8376d8f481164a34b891b926ab22acdc2903e77c4cfbc04c0ba6363ca7597"
    sha256 high_sierra:    "20688bea4981567848393aeeb1964f2200847f63ee52eb8c68d8fff0e4dd8b45"
    sha256 sierra:         "16e812e4be2247d8e8f4f8a68ba6765ceb5a98e22a08dda288eb99dff2e41ae0"
    sha256 x86_64_linux:   "aa37797eb7ff78caa64082bc7a1aceeb74f8b05a73ce17a4fdbe78770bde4fea"
  end

  keg_only :shadowed_by_macos, "Apple's CLT provides apr (but not apr-util)"

  depends_on "apr"
  depends_on "openssl@1.1"

  uses_from_macos "expat"
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
    (libexec/"lib").install_symlink Dir["#{lib}/#{shared_library("*")}"]

    rm Dir[lib/"**/*.{la,exp}"]

    # No need for this to point to the versioned path.
    inreplace bin/"apu-#{version.major}-config", prefix, opt_prefix
  end

  test do
    assert_match opt_prefix.to_s, shell_output("#{bin}/apu-#{version.major}-config --prefix")
  end
end
