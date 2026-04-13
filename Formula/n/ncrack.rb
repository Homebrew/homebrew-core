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
    end

    # Apply Fedora C99 patch
    # Unmerged PR: https://github.com/nmap/ncrack/pull/127
    patch do
      url "https://src.fedoraproject.org/rpms/ncrack/raw/425a54633e220b6bafca37554e5585e2c6b48082/f/ncrack-0.7-fedora-c99.patch"
      sha256 "7bb5625c29c9c218e79d0957ea3e8d84eb4c0bf4ef2acc81b908fed2cbf0e753"
    end
  end

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "f73a2674042b2e7cf64f321316d88dd2a9f92fa116b6a77d73f2d2f348c6e742"
    sha256 arm64_sequoia: "b21c1901137325fd1923931265abf68349d6d977943b9138ca9572aa507b5cd0"
    sha256 arm64_sonoma:  "159b54f1da255b7c861fb23320c8e15012612f75cdbe8ee9123c6384b408d043"
    sha256 sonoma:        "52d3c2ce600c1124c6b23231bd23ad9342f20481cb94f3ae8b94856c4dabc427"
    sha256 arm64_linux:   "6fd8f73ef2ee53e70fb6e58641425eb6b4e692fd1b891bf6c53d279539e37eaa"
    sha256 x86_64_linux:  "9e0c60c65ad23af0cfa59dfa65d970850ae9fab8d270c105ffc1b0672af75d60"
  end

  depends_on "openssl@3"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "./configure", "--with-openssl=#{Formula["openssl@3"].opt_prefix}", *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    assert_match version.to_f.to_s, shell_output("#{bin}/ncrack --version")
  end
end
