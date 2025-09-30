class Aide < Formula
  desc "File and directory integrity checker"
  homepage "https://aide.github.io/"
  url "https://github.com/aide/aide/releases/download/v0.19.2/aide-0.19.2.tar.gz"
  sha256 "23762b05f46111edeb3c8a05016c8731c01bdb8c1f91be48c156c31ab85e74c4"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a947c75c477cf411400106de11a991089a34c6078ddb353c17fe93425f546468"
    sha256 cellar: :any,                 arm64_sequoia: "9e5b60be5b1430a10b7c986292bfec5197b6c7af149ee8c599cec7c65309d264"
    sha256 cellar: :any,                 arm64_sonoma:  "7806be9d00e0f7692ed878edae17173fad9b008501c611b48d0abb0c05055274"
    sha256 cellar: :any,                 arm64_ventura: "4ce4a584208aec836c39a954a59970511898e3cb67db66a0054be1a52f7137cf"
    sha256 cellar: :any,                 sonoma:        "ca382368cb70c1d567c2b9d61394f3f27db967b4e86ce570fa4d06f1d66c2d3b"
    sha256 cellar: :any,                 ventura:       "7a15c93adff7e9a842966ab65b253d3dbcc2e7a30f54d20971e55f54aaab29a7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d3da22175d632c8fbbfc6ba3b7ea851c15ebcb7628d31830f8923cf063acb861"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "886b88eb65a9e7affb0b9f504e45f72bbbbeaefeef112d77a0eb0fbc6c2d55db"
  end

  head do
    url "https://github.com/aide/aide.git", branch: "master"
    depends_on "autoconf" => :build
    depends_on "autoconf-archive" => :build
    depends_on "automake" => :build
    depends_on "bison" => :build
  end

  depends_on "pkgconf" => :build

  depends_on "libgcrypt"
  depends_on "libgpg-error"
  depends_on "pcre2"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "curl"
  uses_from_macos "zlib"

  conflicts_with cask: "aide-app"

  def install
    # use sdk's strnstr instead
    ENV.append_to_cflags "-DHAVE_STRNSTR"

    system "sh", "./autogen.sh" if build.head?

    args = %W[
      --disable-static
      --with-zlib
      --sysconfdir=#{etc}
    ]

    args << if OS.mac?
      "--with-curl"
    else
      "--with-curl=#{Formula["curl"].prefix}"
    end

    system "./configure", *args, *std_configure_args
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
    system bin/"aide", "--config-check", "-c", "aide.conf"
  end
end
