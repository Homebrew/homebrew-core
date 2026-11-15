class Ncrack < Formula
  desc "Network authentication cracking tool"
  homepage "https://nmap.org/ncrack/"
  # License is GPL-2.0-only with non-representable exceptions and an OpenSSL exception.
  # See the installed COPYING file for full details of license terms.
  license :cannot_represent
  revision 1
  head "https://github.com/nmap/ncrack.git", branch: "master"

  stable do
    url "https://github.com/nmap/ncrack/archive/refs/tags/0.7.tar.gz"
    sha256 "f3f971cd677c4a0c0668cb369002c581d305050b3b0411e18dd3cb9cc270d14a"

    # Fix build with GCC 10+. Remove in the next release.
    patch do
      url "https://github.com/nmap/ncrack/commit/af4a9f15a26fea76e4b461953aa34ec0865d078a.patch?full_index=1"
      sha256 "273df2e3bc0733b97a258a9bea2145c4ea36e10b5beaeb687b341e8c8a82eb42"
      type :backport
      resolves "https://github.com/nmap/ncrack/pull/83"
    end

    # Apply Fedora C99 patch
    patch do
      url "https://src.fedoraproject.org/rpms/ncrack/raw/425a54633e220b6bafca37554e5585e2c6b48082/f/ncrack-0.7-fedora-c99.patch"
      sha256 "7bb5625c29c9c218e79d0957ea3e8d84eb4c0bf4ef2acc81b908fed2cbf0e753"
      type :unofficial
      resolves "https://github.com/nmap/ncrack/pull/127"
    end
  end

  bottle do
    rebuild 2
    sha256 arm64_golden_gate: "65094a52b2c9793ea270cef78fb031aa8791512ba07081f6622b42fa2a2f7bb2"
    sha256 arm64_tahoe:       "85017d5ac2d1fd2dc639b61f71c86369b39bb32bde557388bd664cbb54db0161"
    sha256 arm64_sequoia:     "0861dda9a4b22f65928d52d2ef0f3b5c62d3581915cd01047bebde9fa8be4066"
    sha256 arm64_linux:       "b710bf67ad6f53f0eef7ecf99d084cb0522570f27365fe44b2400a5a3bb7397c"
    sha256 x86_64_linux:      "d53db34925dae25f4faefe250f69afda50f22815bce28df5ef5782605078e0f0"
  end

  depends_on "openssl@4"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  # Apply open PR to support OpenSSL 4 which is used by Ubuntu and Fedora
  patch do
    url "https://github.com/nmap/ncrack/commit/76a0eabaad402ed935c1294f98663cf58a806a06.patch?full_index=1"
    sha256 "7eb44ecf8b43fa2d201763bafe411db8606643064bf1cf3e78531c13f5e2138f"
    type :unofficial
    resolves "https://github.com/nmap/ncrack/pull/147"
  end

  deny_network_access!

  def install
    system "./configure", "--with-openssl=#{formula_opt_prefix("openssl@4")}", *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    assert_match version.to_f.to_s, shell_output("#{bin}/ncrack --version")
  end
end
