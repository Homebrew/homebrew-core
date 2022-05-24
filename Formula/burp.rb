class Burp < Formula
  desc "Network backup and restore"
  homepage "https://burp.grke.org/"
  license "AGPL-3.0"
  revision 1

  stable do
    url "https://downloads.sourceforge.net/project/burp/burp-2.2.18/burp-2.2.18.tar.bz2"
    sha256 "9c0c5298d8c2995d30d4e1a63d2882662e7056ce2b0cee1f65d7d0a6775c0f81"

    resource "uthash" do
      url "https://github.com/troydhanson/uthash.git",
          revision: "8b214aefcb81df86a7e5e0d4fa20e59a6c18bc02"
    end
  end

  livecheck do
    url :stable
    regex(%r{url=.*?/burp[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_monterey: "83b2b4ab24707d1ce623e5b17fc41c28c531efe201082732875155df0bdcd56e"
    sha256 arm64_big_sur:  "c577ab1379ef9343a399ddf347f52ceb5949eb86f68aa24f79aa8f566fbd8e70"
    sha256 monterey:       "a674c5b0882eb57cfd20f53b84cacf4c02f7bc9c24c468996d3b4f5873a1ccbf"
    sha256 big_sur:        "2b7114e8a7c736749bf2a073c2cd34bd269ce2129c16035ee9d4df4c7faacfef"
    sha256 catalina:       "a028ea604ba4bbb5abe2d9985e94ece9f673cf33e35191063eb91e356923e982"
    sha256 mojave:         "f45062f56a6cc3bc9ba09b84d9f44e599015387d6d31b0ae8a289fa74a904021"
    sha256 high_sierra:    "1855c5623a4d7ec1ed397f2646772d807a127f80f196c41dcae0efe7615afd8d"
    sha256 sierra:         "157aa6cc33291ec50b8597b3bd97b08e0a92f79e634ec122eb0911e86bc395c9"
    sha256 x86_64_linux:   "938917e5c0bc5901f546caee65cb0a0f37284a00b5a6d0a9e2df78d0fd3161b5"
  end

  head do
    url "https://github.com/grke/burp.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build

    resource "uthash" do
      url "https://github.com/troydhanson/uthash.git"
    end
  end

  depends_on "pkg-config" => :build
  depends_on "librsync"
  depends_on "openssl@1.1"
  uses_from_macos "zlib"

  def install
    resource("uthash").stage do
      (buildpath/"uthash/include").install "src/uthash.h"
    end

    ENV.prepend "CPPFLAGS", "-I#{buildpath}/uthash/include"

    system "autoreconf", "-fiv" if build.head?

    system "./configure", "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}/burp",
                          "--sbindir=#{bin}",
                          "--localstatedir=#{var}"

    system "make", "install-all"
  end

  def post_install
    (var/"run").mkpath
    (var/"spool/burp").mkpath
  end

  def caveats
    <<~EOS
      Before installing the launchd entry you should configure your burp client in
        #{etc}/burp/burp.conf
    EOS
  end

  plist_options startup: true

  service do
    run [opt_bin/"burp", "-a", "t"]
    run_type :interval
    keep_alive false
    interval 1200
    working_dir HOMEBREW_PREFIX
  end

  test do
    system bin/"burp", "-V"
  end
end
