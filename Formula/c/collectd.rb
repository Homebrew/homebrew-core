class Collectd < Formula
  desc "Statistics collection and monitoring daemon"
  homepage "https://collectd.org/"
  license "MIT"
  revision 10

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
    sha256 arm64_tahoe:   "96b35082902fad36f2eebfadecfb13424f4f019cb051fb7cc8a80aa10369e618"
    sha256 arm64_sequoia: "bd6bbc019cd159129bf0ae691889eb75bdb223852a510b968ac1d9f80e2f0fbe"
    sha256 arm64_sonoma:  "bb7547382bb6e48626b092b4176b71bce3c3931d7aae4e0f1f181ee82429eeda"
    sha256 sonoma:        "a43c1a21faa9efe89488e6f8804bafbe299ffa1ef88700257a274b964b9ab94f"
    sha256 arm64_linux:   "ffdcf420ea811f4ed5dfb2679314260669bd20fa13ff7b309fe112eae86758f7"
    sha256 x86_64_linux:  "34583c194f6ce6c0b08ebd64e91b079083b038139c24bd9a8d93c1ba35883526"
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
      pid = spawn sbin/"collectd", "-f", "-C", "collectd.conf"
      sleep 3
      assert_path_exists log, "Failed to create log file"
      assert_match "plugin \"memory\" successfully loaded.", log.read
    ensure
      Process.kill("SIGINT", pid)
      Process.wait(pid)
    end
  end
end
