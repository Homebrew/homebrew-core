class AprUtil < Formula
  desc "Companion library to apr, the Apache Portable Runtime library"
  homepage "https://apr.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=apr/apr-util-1.6.5.tar.bz2"
  mirror "https://archive.apache.org/dist/apr/apr-util-1.6.5.tar.bz2"
  sha256 "96de1dd6f6a0476d2d2e7964926d8c1ddc3bb0e210e1b1812d3ba5a454a392e2"
  license "Apache-2.0"

  bottle do
    sha256 arm64_tahoe:   "2bc24b7b834b7f9e8f0ac799189687123835a389b3ce68584d94e8b02b38b178"
    sha256 arm64_sequoia: "a5a55680dccde97bb0d565744c106f44fac7c8a1bbd25e556ed9e950ca368f9f"
    sha256 arm64_sonoma:  "4a09d5ce3a12a19287c15427ad1bbb1d02fc9aa8e6080028bbabaf2858a65af7"
    sha256 sonoma:        "b3c6f79539d6df8bd066f167d383b32ef82bed80ce1dc0f166d033b978ce368a"
    sha256 arm64_linux:   "dfb776cd6ca7cad412673b96b86d0011359374f629e50388bcce1fce63f3a3bb"
    sha256 x86_64_linux:  "2b544e6c6da545dc8e822283ae291abe55561b0e3f2ab0355cd929612fd3071a"
  end

  keg_only :shadowed_by_macos, "Apple's CLT provides apr (but not apr-util)"

  depends_on "apr"
  depends_on "openssl@3"

  uses_from_macos "expat"
  uses_from_macos "libxcrypt"
  uses_from_macos "sqlite"

  on_linux do
    depends_on "unixodbc"
  end

  def install
    system "./configure", "--with-apr=#{formula_opt_prefix("apr")}",
                          "--with-crypto",
                          "--with-openssl=#{formula_opt_prefix("openssl@3")}",
                          "--without-pgsql",
                          *std_configure_args
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
