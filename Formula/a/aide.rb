class Aide < Formula
  desc "File and directory integrity checker"
  homepage "https://aide.github.io/"
  url "https://github.com/aide/aide/releases/download/v0.19.5/aide-0.19.5.tar.gz"
  sha256 "6b004557e9493048ceb5fa84fb44b904c16e23bed8850dc21316e7c44247a350"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "0a5ed63b74a93bfad3ab08d88509e4fcf6bc4f8772048812369d616168b00f58"
    sha256 cellar: :any, arm64_tahoe:       "f0bc01192335ba42f2a506089bd662604726f0173fb326a5e6751d4074ad9cb1"
    sha256 cellar: :any, arm64_sequoia:     "c2317720077166aa280cca923c9335322c2eecbeea05aafefdcdb5904020a8f7"
    sha256 cellar: :any, arm64_linux:       "92d70d69941ce479d3f028b6fd3814f982c6040146dd04f604a1a1a08265c344"
    sha256 cellar: :any, x86_64_linux:      "0290a68491db40f1145dbe66a0e77912233e08eb30b64bc7b2dc35d2e24edbeb"
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
