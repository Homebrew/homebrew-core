class Aide < Formula
  desc "File and directory integrity checker"
  homepage "https://aide.github.io/"
  url "https://github.com/aide/aide/releases/download/v0.19.3/aide-0.19.3.tar.gz"
  sha256 "6513170bb5b8c22802dd1b72f02d8aa9f432aef2b4470522db03e755212a3f47"
  license "GPL-2.0-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "e84fe8e7cdbd88400214740e38b924ff7bdfe449b2ef2de235d4e9751e3e9225"
    sha256 cellar: :any,                 arm64_sequoia: "810d048246d7ce9e0ddb19468037f5469af08414ab9fcfa121c0489eb0214958"
    sha256 cellar: :any,                 arm64_sonoma:  "b65c8a523b64e3895a18a94e79c9edf0ce7190bccd07fed057671c6e3f8ca81e"
    sha256 cellar: :any,                 sonoma:        "4ea8bb4acbd0926da91bdd8ee2ed6f6adea517aa51a3abce5f62e248425f2a89"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b2f434138bea735edc207d22050845a60d34b494161a7d2f339bad6c11acba8f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cd4e10567325568eadfb6dcde6da800b5a682212bddc7a878554fccbdb251582"
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

  on_linux do
    depends_on "zlib-ng-compat"
  end

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
