class Aide < Formula
  desc "File and directory integrity checker"
  homepage "https://aide.github.io/"
  url "https://github.com/aide/aide/releases/download/v0.18.3/aide-0.18.3.tar.gz"
  sha256 "d47da12c4bf085bfdf1828e087a1db5195a4d217ff4c89f40dbd94e2a887a6a2"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "960cacda88e24147009b31369282cf927eae19ba8e0a86a16b069b3f660e4946"
    sha256 cellar: :any,                 arm64_monterey: "f76039175f3ef01c61e6a63ca8d30f9a52fe540029f56fcc7273bfe5a1190875"
    sha256 cellar: :any,                 arm64_big_sur:  "d7a0982f4cb06ba0fe8cc1f8c0ddeea3629e1f0fbda5e2453803774fc6cc657b"
    sha256 cellar: :any,                 ventura:        "8e33ab392717114f94319c37206c181b80ec44117e07d127dcb64908d8353168"
    sha256 cellar: :any,                 monterey:       "a689028731aa1b23db18c2749286ffcbeb4511aa9ed91a2400d511e7dcae12ed"
    sha256 cellar: :any,                 big_sur:        "d710b6d40e24be3aeb55887ab423f0dd71cadbdbb4b16f492b1e2f089e788081"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "44c50b348f3896af459ed4f9e1e1aeba0886e5782c0fbbdda1df01b6e921b75b"
  end

  head do
    url "https://github.com/aide/aide.git", branch: "master"
    depends_on "autoconf" => :build
    depends_on "autoconf-archive" => :build
    depends_on "automake" => :build
    depends_on "bison" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "libgcrypt"
  depends_on "libgpg-error"
  depends_on "pcre2"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "curl"

  def install
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

    args << if OS.mac?
      "--with-curl"
    else
      "--with-curl=#{Formula["curl"].prefix}"
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
