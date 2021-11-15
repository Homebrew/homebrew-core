class Aide < Formula
  desc "File and directory integrity checker"
  homepage "https://aide.github.io/"
  url "https://github.com/aide/aide/releases/download/v0.17.3/aide-0.17.3.tar.gz"
  sha256 "a2eb1883cafaad056fbe43ee1e8ae09fd36caa30a0bc8edfea5d47bd67c464f8"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "1a85f21fbf5d8fc595861ec5896146779706cea3c7fcf2d472340f342ab20cbe"
    sha256 cellar: :any,                 arm64_big_sur:  "bc933e63d10ab2fdd5d974c32c3f0898f37bf9d95f3e74129eae1b860bc785c8"
    sha256 cellar: :any,                 monterey:       "989785b6497c9b6a93789fd84ebf0d1b794cc45618de12ffba80026d8603cdc7"
    sha256 cellar: :any,                 big_sur:        "39d24815ba23cd86b3a31c18e7e27b6c4a231dfbfb9e6fb035efec84a68b1ccf"
    sha256 cellar: :any,                 catalina:       "b765af2fe87ab4494ddb51680f9fa151cf7d91b853d1a6bc5f1c1c0e14eda155"
    sha256 cellar: :any,                 mojave:         "a24aedaabc8dfa8341e7713e43c994db019fb12747a497ac735a7864079cedb0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "296511a7306bbd01163594427a1ce69c92cbf83efc17f9de63c3ec590a881fd8"
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
