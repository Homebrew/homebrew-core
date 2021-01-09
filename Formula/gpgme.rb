class Gpgme < Formula
  desc "Library access to GnuPG"
  homepage "https://www.gnupg.org/related_software/gpgme/"
  url "https://www.gnupg.org/ftp/gcrypt/gpgme/gpgme-1.15.1.tar.bz2"
  sha256 "eebc3c1b27f1c8979896ff361ba9bb4778b508b2496c2fc10e3775a40b1de1ad"
  license "LGPL-2.1-or-later"

  livecheck do
    url "https://gnupg.org/ftp/gcrypt/gpgme/"
    regex(/href=.*?gpgme[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    cellar :any
    sha256 "6de40ec526a4d87f6caba431dc5cb8c48ac490cc31d76f64b9e3f451c27f3ea2" => :big_sur
    sha256 "15e4e53d82f19a390ccf802bf9ebc5310814eef0ee482701a19f2da66737a9c7" => :arm64_big_sur
    sha256 "804b505d6702fb22c25c93a7832648a23aefc877c4d660ce5c7a9026c9442bc7" => :catalina
    sha256 "99d0cc2cb9dcd2b7d38bb48627f3b740d483d7f9e64d6fd6690941ecb5731f2b" => :mojave
    sha256 "02bd3a9334b19890b043256a406bce8c61083fd56a71e4966161de86fd6aa4d8" => :high_sierra
  end

  depends_on "python@3.9" => [:build, :test]
  depends_on "swig" => :build
  depends_on "gnupg"
  depends_on "libassuan"
  depends_on "libgpg-error"

  def install
    ENV["PYTHON"] = Formula["python@3.9"].opt_bin/"python3"

    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--enable-static"
    system "make"
    system "make", "install"

    # avoid triggering mandatory rebuilds of software that hard-codes this path
    inreplace bin/"gpgme-config", prefix, opt_prefix
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gpgme-tool --lib-version")
    system Formula["python@3.9"].opt_bin/"python3", "-c", "import gpg; print(gpg.version.versionstr)"
  end
end
