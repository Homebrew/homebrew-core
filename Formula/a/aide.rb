class Aide < Formula
  desc "File and directory integrity checker"
  homepage "https://aide.github.io/"
  url "https://github.com/aide/aide/releases/download/v0.19.1/aide-0.19.1.tar.gz"
  sha256 "6df8bf5f0403d74af7dbdb91eb3c8f61fe07e964669db8cfa1ee7e4ee3e90b52"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "1db9339d12955b3ee47cdabb14e9ab9618793c1f00989b92112d632400dea4b8"
    sha256 cellar: :any,                 arm64_sonoma:  "90faecbf9e722f1b526ffd770e144c50d7c2a627b2d34e2ac351b6bf97356a56"
    sha256 cellar: :any,                 arm64_ventura: "9c726e4acc2fbf41293be8761304e5a92321a182a3ecd4d6c4792179dc6284e1"
    sha256 cellar: :any,                 sonoma:        "256693094f624cde2defe05edfb2adecdedde9d64a35136dd67baacab36e515a"
    sha256 cellar: :any,                 ventura:       "8da099fd2d74b0283a7f1ba7afbc3da8c60b5a7fcd3918f852c66a74d72e54a7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ff9042ed674c80d241ee8cd8db10b0a95bd8b60d92ea98993472f3a36eb555cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "50c31d78bffbbbf5af4d9b88028534d9cec1c2e46d4f9c4f89ed6e592c6bc883"
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
