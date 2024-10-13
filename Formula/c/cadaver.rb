class Cadaver < Formula
  desc "Command-line client for DAV"
  homepage "https://notroj.github.io/cadaver/"
  url "https://notroj.github.io/cadaver/cadaver-0.24.tar.gz"
  sha256 "46cff2f3ebd32cd32836812ca47bcc75353fc2be757f093da88c0dd8f10fd5f6"
  license "GPL-2.0-only"

  livecheck do
    url :homepage
    regex(/href=.*?cadaver[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "1ddf0b7918bade1b595f7883371fd7dae26f81938688890951f3a46b3a54e20e"
    sha256 cellar: :any,                 arm64_sonoma:   "1d97d4fffb780e41d1202d716cb9c509c7883ab2da70ac59c0439fbb910a8908"
    sha256 cellar: :any,                 arm64_ventura:  "c48264ae39d915f8cdb905a8b8807d39205edc892f40163cfc07d09ed8f7be75"
    sha256 cellar: :any,                 arm64_monterey: "7b80acb805a75e568a23999803cba218418d30fcf686e81226b8922adad0d4be"
    sha256 cellar: :any,                 arm64_big_sur:  "42fd4197b8eb2bc2e6d6dc3dd0864c497c697bcc497fd4e5994f7a55880f7629"
    sha256 cellar: :any,                 sonoma:         "e4e7e28823f9863cf1c5a140333816fc4a48ee034abd0d70b20ba9c047e9bed1"
    sha256 cellar: :any,                 ventura:        "69364af64cd35d26b327788d6a6851f3bef4adccb62a4ee2de0b2925f2fd03c9"
    sha256 cellar: :any,                 monterey:       "43eab9ac0dcb4d73e38f20d79989613b30f075af20b2496728362c82a37c82c0"
    sha256 cellar: :any,                 big_sur:        "d10e0968b5b4402e13db9871b9e26d34fd923f926e1f3d6cd89342dd9ca32fe4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b1833b0bdb9598c89320a80dd6c92137c2b3dacae8622e60b60782883d031d32"
  end

  head do
    url "https://github.com/notroj/cadaver.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gettext" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
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
    else
      # Allow building with `neon` 33. Fixed upstream but would require regenerating configure
      # Ref: https://github.com/notroj/cadaver/commit/2433126db25ffd38dc11ef847614e479141cc229
      inreplace "configure", "in 27 28 29 30 31 32; do", "in 27 28 29 30 31 32 33; do"
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
