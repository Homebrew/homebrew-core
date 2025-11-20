class Collectd < Formula
  desc "Statistics collection and monitoring daemon"
  homepage "https://collectd.org/"
  license "MIT"
  revision 8

  stable do
    url "https://storage.googleapis.com/collectd-tarballs/collectd-5.12.0.tar.bz2"
    sha256 "5bae043042c19c31f77eb8464e56a01a5454e0b39fa07cf7ad0f1bfc9c3a09d6"

    # Fix -flat_namespace being used on Big Sur and later.
    patch do
      url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/libtool/configure-big_sur.diff"
      sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
    end
  end

  livecheck do
    url "https://www.collectd.org/download.html"
    regex(/href=.*?collectd[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 arm64_tahoe:   "b5f482fbf1af2823274e44bcb25a86fc6b402c26e635f3f8666b5f504cbc7540"
    sha256 arm64_sequoia: "58f7a44814b1a467e4f68fcf719069fe352920ce6e800fc5d60e8ad2e6af1332"
    sha256 arm64_sonoma:  "ceb6cf730de48b1f6eadfc3784060f0b6ed437c3a4fcb7f991e75853eb0d8295"
    sha256 arm64_ventura: "756fa1c1b080652bc6654718c11f5955b1a674b319eb848609e0416415a0cde1"
    sha256 sonoma:        "74e6ebaf66605da54399207a4f083833b39a90f6ff9edb92c82673f874af5e09"
    sha256 ventura:       "cea97da9e5ba92d5d02fb688cc72bf698f245e5d849f44f2d3419f64f1ed5000"
    sha256 arm64_linux:   "ee5c347f93b603ae28b0cc8f952a7ed5cca462dee6e429cf80d7e6475b8bc6e8"
    sha256 x86_64_linux:  "5e73f288cbe0d9d1bd8e35b1782593ab8ef268d41bd05e34913bc63678d926d1"
  end

  head do
    url "https://github.com/collectd/collectd.git", branch: "main"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "pkgconf" => :build
  depends_on "libgcrypt"
  depends_on "libtool"
  depends_on "net-snmp"
  depends_on "protobuf-c"
  depends_on "riemann-client"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "perl"

  on_macos do
    depends_on "libgpg-error"
  end

  def install
    # Workaround for: Built-in generator --c_out specifies a maximum edition
    # PROTO3 which is not the protoc maximum 2023.
    # Remove when fixed in `protobuf-c`:
    # https://github.com/protobuf-c/protobuf-c/pull/711
    ENV["PROTOC_C"] = Formula["protobuf"].opt_bin/"protoc"

    args = %W[
      --localstatedir=#{var}
      --disable-java
      --enable-write_riemann
    ]
    args << "--with-perl-bindings=PREFIX=#{prefix} INSTALLSITEMAN3DIR=#{man3}" if OS.linux?

    system "./build.sh" if build.head?
    system "./configure", *args, *std_configure_args
    system "make", "install"
  end

  service do
    run [opt_sbin/"collectd", "-f", "-C", etc/"collectd.conf"]
    keep_alive true
    error_log_path var/"log/collectd.log"
    log_path var/"log/collectd.log"
  end

  test do
    log = testpath/"collectd.log"
    (testpath/"collectd.conf").write <<~EOS
      LoadPlugin logfile
      <Plugin logfile>
        File "#{log}"
      </Plugin>
      LoadPlugin memory
    EOS
    begin
      pid = fork { exec sbin/"collectd", "-f", "-C", "collectd.conf" }
      sleep 3
      assert_path_exists log, "Failed to create log file"
      assert_match "plugin \"memory\" successfully loaded.", log.read
    ensure
      Process.kill("SIGINT", pid)
      Process.wait(pid)
    end
  end
end
