class Cadaver < Formula
  desc "Command-line client for DAV"
  homepage "https://notroj.github.io/cadaver/"
  url "https://notroj.github.io/cadaver/cadaver-0.28.tar.gz"
  sha256 "33e3a54bd54b1eb325b48316a7cacc24047c533ef88e6ef98b88dfbb60e12734"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?cadaver[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "f2bf16931909ac6eec57117bf09175a2e0caa1082d2b6e2ae3b7a8245af29bc7"
    sha256 arm64_sequoia: "d5bcd805b50034bd950a9a5ff34eb57460468f62e8e5790609b41efc0f643699"
    sha256 arm64_sonoma:  "2f7c951cd0fbd473492db2e3e32ca73bd1182d835aa2fa4e16bc18bb599b0fc0"
    sha256 sonoma:        "3149e1aad7c35c9a2d5bcde614fd25a8e53cfd8117c10044867ebcb827fe1cf9"
    sha256 arm64_linux:   "d8a6f3859f5db0c9cd26fbf52e655392bf1a06ca6298aca1d0ddf45e85a53122"
    sha256 x86_64_linux:  "ea95ccc4cb3825ef2732ea6df7864c87016b40915fed14dac542bdff5a0b6868"
  end

  head do
    url "https://github.com/notroj/cadaver.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gettext" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkgconf" => :build
  depends_on "neon"
  depends_on "openssl@3"
  depends_on "readline"

  on_macos do
    depends_on "gettext"
  end

  def install
    if build.head?
      ENV["LIBTOOLIZE"] = "glibtoolize"
      system "./autogen.sh"
    end
    system "./configure", "--with-ssl=openssl",
                          "--with-libs=#{Formula["openssl@3"].opt_prefix}",
                          "--with-neon=#{Formula["neon"].opt_prefix}",
                          *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    assert_match "cadaver #{version}", shell_output("#{bin}/cadaver -V", 255)
  end
end
