class Aide < Formula
  desc "File and directory integrity checker"
  homepage "https://aide.github.io/"
  url "https://github.com/aide/aide/releases/download/v0.19.4/aide-0.19.4.tar.gz"
  sha256 "47ab7c696f0745911479a41f90d7ad99d26536e186d66c4aad093bc72d20ff5f"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "10d0d9b4e9d56b8415b6938eca5de367ed25fc491b76f2cc4eeda9ddd8d94b1b"
    sha256 cellar: :any, arm64_tahoe:       "c92b47bd4c7fddf3ba1851de455927000ea8719595cec515a768458d9601feed"
    sha256 cellar: :any, arm64_sequoia:     "dc9fd722372390254ee6f6ca4f1dc6c85f07749f64f0454e9e7b5e231c5677a6"
    sha256 cellar: :any, arm64_sonoma:      "0ef7b9f6613c803f5d02f46dccfb8c4c1cb532366166315443a6db9ec3e9d87d"
    sha256 cellar: :any, arm64_linux:       "8a3083c66f1d4b4a2a423a4dbd42a6244c74a190d87fdc8339255d341468c691"
    sha256 cellar: :any, x86_64_linux:      "d41686af88dd8a9ecdff16e22ac7267bf79a460d7d3db8299d7e24eb9d5efd97"
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

  deny_network_access!

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
