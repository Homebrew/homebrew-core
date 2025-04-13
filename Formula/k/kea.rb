class Kea < Formula
  desc "DHCP server"
  homepage "https://www.isc.org/kea/"
  license "MPL-2.0"

  stable do
    # NOTE: the livecheck block is a best guess at excluding development versions.
    #       Check https://www.isc.org/download/#Kea to make sure we're using a stable version.
    url "https://ftp.isc.org/isc/kea/2.6.2/kea-2.6.2.tar.gz"
    mirror "https://dl.cloudsmith.io/public/isc/kea-2-6/raw/versions/2.6.2/kea-2.6.2.tar.gz"
    sha256 "8a50b63103734b59c3b8619ccd6766d2dfee3f02e3a5f9f3abc1cd55f70fa424"

    # Backport support for Boost 1.87.0
    patch do
      url "https://gitlab.isc.org/isc-projects/kea/-/commit/81edc181f85395c39964104ef049a195bafb9737.diff"
      sha256 "17fd38148482e61be2192b19f7d05628492397d3f7c54e9097a89aeacf030072"
    end
  end

  livecheck do
    url "ftp://ftp.isc.org/isc/kea/"
    # Match the final component lazily to avoid matching versions like `1.9.10` as `9.10`.
    regex(/v?(\d+\.\d*[02468](?:\.\d+)+?)$/i)
    strategy :page_match
  end

  bottle do
    rebuild 1
    sha256 arm64_sequoia: "0140ea7c9ede2d94efc51caadaf12c062c853d7d3d5cc68a26221b7a37226e83"
    sha256 arm64_sonoma:  "59d717d80b87a2e491e1107105e04f9ef4caaf4d269f458558808777cfceed2e"
    sha256 arm64_ventura: "e6a283e858cc2f08b3db91c7941f2eb0cacda7be81e58b00b8520356fe35e394"
    sha256 sonoma:        "058ce5aeb4d71d54ebf0f6ff98ce7732c8e14d9d509588d48a05d23d488fe8bd"
    sha256 ventura:       "a9bb4722c39d136fcc2641e78ffacdd58cbe1f3e3fb0fe1120e3141a046242a9"
    sha256 arm64_linux:   "ceef0b2966ea631be071f02fb710cf6c3eaf319112203dec5977c45a7d30b0f1"
    sha256 x86_64_linux:  "3db7bc8bbb9a06006c008c199d5412c1e76a771b5d96a769d8014fc65c9ebf4a"
  end

  head do
    url "https://gitlab.isc.org/isc-projects/kea.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkgconf" => :build
  depends_on "boost"
  depends_on "log4cplus"
  depends_on "openssl@3"

  def install
    # Workaround to build with Boost 1.87.0+
    ENV.append "CXXFLAGS", "-std=gnu++14"

    system "autoreconf", "--force", "--install", "--verbose" if build.head?
    system "./configure", "--disable-silent-rules",
                          "--with-openssl=#{Formula["openssl@3"].opt_prefix}",
                          "--sysconfdir=#{etc}",
                          "--localstatedir=#{var}",
                          *std_configure_args
    system "make", "install"
  end

  test do
    system sbin/"keactrl", "status"
  end
end
