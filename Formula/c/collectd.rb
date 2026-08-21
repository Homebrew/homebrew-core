class Collectd < Formula
  desc "Statistics collection and monitoring daemon"
  homepage "https://collectd.org/"
  license "MIT"
  revision 11

  stable do
    url "https://storage.googleapis.com/collectd-tarballs/collectd-5.12.0.tar.bz2"
    sha256 "5bae043042c19c31f77eb8464e56a01a5454e0b39fa07cf7ad0f1bfc9c3a09d6"

    # Fix -flat_namespace being used on Big Sur and later.
    patch do
      file "Patches/libtool/configure-big_sur.diff"
      type :unofficial
    end
  end

  livecheck do
    url "https://www.collectd.org/download.html"
    regex(/href=.*?collectd[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "324dda8ec5aa63c4d4b84b36f6858321e63f31c03e46cf692bf6bce2173df4cd"
    sha256 arm64_sequoia: "7aea2380df608747796f5f7c3aac79ee6c36a301f07beb4ff25db121119a7311"
    sha256 arm64_sonoma:  "4d93f8eb7f727cfaab7784fb1d94c5efb9763447c29d1f9662a9558859dfb74a"
    sha256 sonoma:        "315359880ba2c73615ce322d5a56074e72179c75c694b1ad31ef0f2d0d653e46"
    sha256 arm64_linux:   "3c3fce87eece6ded5ece1b4cf1a377e42df47015287218f88df213c5b299d32d"
    sha256 x86_64_linux:  "6c17fdeb04fee0e5b58e8b08a2c3586f427c1952dfe95f981ae3cf95ce935d27"
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
    ENV["PROTOC_C"] = formula_opt_bin("protobuf")/"protoc"

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
