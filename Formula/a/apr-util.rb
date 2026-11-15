class AprUtil < Formula
  desc "Companion library to apr, the Apache Portable Runtime library"
  homepage "https://apr.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=apr/apr-util-1.6.6.tar.bz2"
  mirror "https://archive.apache.org/dist/apr/apr-util-1.6.6.tar.bz2"
  sha256 "aa77dd25f036731b7246abbfbebe6cc813b42799b62c874bc82bd4e1f90f2918"
  license "Apache-2.0"
  compatibility_version 1

  bottle do
    sha256 arm64_golden_gate: "f7f7174af2e16984ca464ec9fbfd9df33ef2e3c716afb410a024c1d1983f7786"
    sha256 arm64_tahoe:       "272ac1650856bfba7c5b033e3e118c5d28ab271ae7ce6f469eed954d126ab577"
    sha256 arm64_sequoia:     "f62ab082561dd6956e950bf71b4057645c27dfb2e0c2bc36335e103932a1668b"
    sha256 arm64_linux:       "c09d62bca3c07f5adf86ed7eaca967432aea2a5f2c297340372b0d65a0070bc8"
    sha256 x86_64_linux:      "58519c596959f99d7d4e34100ff6dd000756ca9a980b06456ade7105c878560c"
  end

  keg_only :shadowed_by_macos, "Apple's CLT provides apr (but not apr-util)"

  depends_on "apr"
  depends_on "openssl@4"

  uses_from_macos "expat"
  uses_from_macos "libxcrypt"
  uses_from_macos "sqlite"

  on_linux do
    depends_on "unixodbc"
  end

  deny_network_access!

  def install
    system "./configure", "--with-apr=#{formula_opt_prefix("apr")}",
                          "--with-crypto",
                          "--with-openssl=#{formula_opt_prefix("openssl@4")}",
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
