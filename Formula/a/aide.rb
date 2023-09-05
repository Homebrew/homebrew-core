class Aide < Formula
  desc "File and directory integrity checker"
  homepage "https://aide.github.io/"
  url "https://github.com/aide/aide/releases/download/v0.18.6/aide-0.18.6.tar.gz"
  sha256 "8ff36ce47d37d0cc987762d5d961346d475de74bba8a1832fd006db6edd3c10e"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "83a95d3294e93c9e97dce63f90669196c83385b8c9746726b1de80c519dbb989"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "89d4522e294308bb68cb77a6af9b2efac9ed3766f3af891830b760822ec7bfe6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "abc3a66e2bc062aec14e805564de1640d916b124b53f6fc8df5e9539fecdc869"
    sha256 cellar: :any_skip_relocation, ventura:        "55b3325f8102ad90e22d655a683d5d92fada2acc3bb2a9b3ef6a5d7957aa7b7d"
    sha256 cellar: :any_skip_relocation, monterey:       "b8b22c018153d7d4b8ac0540455d975066e1be9679dc224cf062d24972df50be"
    sha256 cellar: :any_skip_relocation, big_sur:        "3399423faa40213b9206f1ca09f5979d1ae8d5b19f22d80485b099b2d0cf41d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9212d924afb1b8912d17b0c0242e4dc7a5d837199f0ed4e43f568c2f992cf601"
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
