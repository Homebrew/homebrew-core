class Collectd < Formula
  desc "Statistics collection and monitoring daemon"
  homepage "https://collectd.org/"
  license "MIT"
  revision 7

  stable do
    url "https://storage.googleapis.com/collectd-tarballs/collectd-5.12.0.tar.bz2"
    sha256 "5bae043042c19c31f77eb8464e56a01a5454e0b39fa07cf7ad0f1bfc9c3a09d6"

    # Fix -flat_namespace being used on Big Sur and later.
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
      sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
    end
  end

  livecheck do
    url "https://www.collectd.org/download.html"
    regex(/href=.*?collectd[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia:  "8a439840e29532604b8f7e7f69660e4f10497544a68f3fce5690394cb8de6e2d"
    sha256 arm64_sonoma:   "feeabfab71b4779d284f35c81db87618f5c27c9567cc2aa817c1ae7e525c29b0"
    sha256 arm64_ventura:  "27b3ab3603d68a565dab7e7076d0d065692c6f4621094e4b8f0b2608257c092d"
    sha256 arm64_monterey: "ea60e985f3b9fa1cea0a6ea0cdd488076c7f5fb913ed874dc97b076617c76c31"
    sha256 sonoma:         "964fc480f251425f36043c3f88bd14bb43314e122ef1adbd3715e935c8593076"
    sha256 ventura:        "7ca3d7a8572daa17aa7f11b861c043b09b3f407023d4e64af19f1417f5f9e3ba"
    sha256 monterey:       "b92aff0140b2d791ba48e7a17e7ab7e522e07f4024589217090dca4b838c8c85"
    sha256 x86_64_linux:   "02684fac023ca6b20bc8a4dddc1a03005a0003201455200ba313be29ba4dab25"
  end

  head do
    url "https://github.com/collectd/collectd.git", branch: "main"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "pkg-config" => :build
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

    args = std_configure_args + %W[
      --localstatedir=#{var}
      --disable-java
      --enable-write_riemann
    ]
    args << "--with-perl-bindings=PREFIX=#{prefix} INSTALLSITEMAN3DIR=#{man3}" if OS.linux?

    system "./build.sh" if build.head?
    system "./configure", *args
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
      assert_predicate log, :exist?, "Failed to create log file"
      assert_match "plugin \"memory\" successfully loaded.", log.read
    ensure
      Process.kill("SIGINT", pid)
      Process.wait(pid)
    end
  end
end
