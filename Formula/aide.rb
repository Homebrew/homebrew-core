class Aide < Formula
  desc "File and directory integrity checker"
  homepage "https://aide.github.io/"
  url "https://github.com/aide/aide/releases/download/v0.17/aide-0.17.tar.gz"
  sha256 "4fd88d1d5ddc70c698c6519ebbc05c8d32c3f6d8137bbfdefeaebaafd6db867b"
  license "GPL-2.0-or-later"

  bottle do
    cellar :any
    sha256 "ed33989aed9c6b7a0a20753d567694c5204d96f4f9b2d91888c3f79172b4359f" => :big_sur
    sha256 "fdc026017c2c2095497fad0623e343583e4f3a2dd07260c3fe24ffa95cdd5391" => :arm64_big_sur
    sha256 "8cf98b716cfdc2e06e059b5c0f780db5940c4fda116c3b0543f8e19bd76a9817" => :catalina
    sha256 "bb68fa349609a0221b2138e3596ceb803242862b771bb0b76440057e31201050" => :mojave
    sha256 "fff1a3e469346d9181f73d8c3d734801b900c765308f3c36495b1801fb3ad897" => :high_sierra
    sha256 "77aef168355fa73b01b0967d80058582f7387997ba2c7f7b7aad0eb335939488" => :sierra
  end

  head do
    url "https://github.com/aide/aide.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "libgcrypt"
  depends_on "libgpg-error"
  depends_on "pcre"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "curl"

  def install
    # fix `fatal error: 'error.h' file not found`
    # remove in next release
    inreplace "include/aide.h", "#include \"error.h\"", ""

    # use sdk's strnstr instead
    ENV.append_to_cflags "-DHAVE_STRNSTR"

    system "sh", "./autogen.sh" if build.head?

    args = %W[
      --disable-lfs
      --disable-static
      --with-zlib
      --sysconfdir=#{etc}
      --prefix=#{prefix}
    ]
    on_macos do
      args << "--with-curl"
    end
    on_linux do
      args << "--with-curl=" + Formula["curl"].prefix
    end

    system "./configure", *args

    system "make", "install"
  end

  test do
    (testpath/"aide.conf").write <<~EOS
      database_in = file:/var/lib/aide/aide.db
      database_out = file:/var/lib/aide/aide.db.new
      database_new = file:/var/lib/aide/aide.db.new
      gzip_dbout = yes
      report_summarize_changes = yes
      report_grouped = yes
      log_level = info
      database_attrs = sha256
      /etc p+i+u+g+sha256
    EOS
    system "#{bin}/aide", "--config-check", "-c", "aide.conf"
  end
end
