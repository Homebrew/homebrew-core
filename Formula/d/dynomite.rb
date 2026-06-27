class Dynomite < Formula
  desc "Generic dynamo implementation for different k-v storage engines"
  homepage "https://github.com/Netflix/dynomite"
  url "https://github.com/Netflix/dynomite/archive/refs/tags/v0.6.22.tar.gz"
  sha256 "9c3c60d95b39939f3ce596776febe8aa00ae8614ba85aa767e74d41e302e704a"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "b80a0fafcbefc40ecbe2c372a3ef9159512a4b85e0838ac65d26f5225ceaa546"
    sha256 arm64_sequoia: "d2417262050f0f0272c2c76db3e1f4a859b6b424a03c77e2091d903279b0ce62"
    sha256 arm64_sonoma:  "f36565e700a533a4282f783fe05d70c88e9e306c91b020e3298beddb6989cdc5"
    sha256 sonoma:        "10b55d281b83fd69944c86ba6cbbb3a89aa3cbf978e41e9effa6190f3d07d222"
    sha256 arm64_linux:   "5b7a2482637638c1369760bdfa130dff0bf9df35aa3ff5c9370e9d434315a5bc"
    sha256 x86_64_linux:  "c29a22ea448af26e89c11b28101e4d73a510d23d1b18aea9c177b70745c969ea"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "openssl@4"

  # Apply fix for -fno-common from gcc-10 branch
  # Ref: https://github.com/Netflix/dynomite/issues/802
  patch do
    on_linux do
      url "https://github.com/dmolik/dynomite/commit/303d4ecae95aee9540c48ceac9e7c0f2137a4b52.patch?full_index=1"
      sha256 "a195c75e49958b4ffcef7d84a5b01e48ce7b37936c900e466c1cd2d96b52ac37"
    end
  end

  def install
    # Work around build failure on recent Clang
    # Issue ref: https://github.com/Netflix/dynomite/issues/818
    if DevelopmentTools.clang_build_version >= 1500
      ENV.append_to_cflags "-Wno-implicit-function-declaration -Wno-int-conversion"
    end
    ENV.append "CFLAGS", "-std=gnu17" if DevelopmentTools.clang_build_version >= 1700

    args = ["--disable-silent-rules", "--sysconfdir=#{pkgetc}"]
    # Help old config script for bundled libyaml identify arm64 linux
    args << "--build=aarch64-unknown-linux-gnu" if OS.linux? && Hardware::CPU.arm64?

    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", *args, *std_configure_args
    system "make"
    system "make", "install"
    pkgetc.install Dir["conf/*"]
  end

  test do
    stats_port = free_port

    cp etc/"dynomite/redis_single.yml", testpath
    inreplace "redis_single.yml" do |s|
      s.gsub! ":8102", ":#{free_port}"
      s.gsub! ":8101", ":#{free_port}"
      s.gsub! ":22122", ":#{free_port}"
      s.gsub! ":22222", ":#{stats_port}"
    end

    spawn sbin/"dynomite", "-c", "redis_single.yml"
    sleep 5
    assert_match "OK", shell_output("curl -s 127.0.0.1:#{stats_port}")
  end
end
