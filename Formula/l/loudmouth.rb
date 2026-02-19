class Loudmouth < Formula
  desc "Lightweight C library for the Jabber protocol"
  homepage "https://mcabber.com"
  license "LGPL-2.1-or-later"

  stable do
    url "https://mcabber.com/files/loudmouth/loudmouth-1.5.4.tar.bz2"
    sha256 "31cbc91c1fddcc5346b3373b8fb45594e9ea9cc7fe36d0595e8912c47ad94d0d"

    # Fix -flat_namespace being used on Big Sur and later.
    patch do
      url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/libtool/configure-big_sur.diff"
      sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
    end
  end

  livecheck do
    url :homepage
    regex(/href=.*?loudmouth[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "6b102ebfa05ec64bba31c02b27a116e39020b136df40c25ddb1509d5fed1bef6"
    sha256 cellar: :any,                 arm64_sequoia:  "43729c1c6d565d8c39c43603f74ed9d9cec9c0245449e2b8e19f9b991fc44ea1"
    sha256 cellar: :any,                 arm64_sonoma:   "5c27c1b17205765db82cf291a090e65e50b6a5194fda067d000d70d58cf3717e"
    sha256 cellar: :any,                 arm64_ventura:  "439e0305cb6c6fa9305ef3ddeb6d35e330d35d245ac836fce6435c34bfa88e89"
    sha256 cellar: :any,                 arm64_monterey: "56ce5d15bd9625075e7160268936d0197a1116c1b3a095ebbbf190d2ac9becc7"
    sha256 cellar: :any,                 arm64_big_sur:  "0b60046b8a592ab656ed824b75774f2e9e8f9749b0a5edb024190019c36da766"
    sha256 cellar: :any,                 sonoma:         "923446f9175c19b756f93a709597f676dc328b754899fecabf0ae7a4835dc02e"
    sha256 cellar: :any,                 ventura:        "7fbed66f2d4ded808afb89a793ae6355a9134fd361fdba0ab0e930be4535743d"
    sha256 cellar: :any,                 monterey:       "890ebdd35bf9275e771984de61b38557ff279e61d15e8c9d11813def0b65689a"
    sha256 cellar: :any,                 big_sur:        "d770f0cd1a81375c306d0bc6fdd81610d27bc844fd5086518aaa7f8fa6252a14"
    sha256 cellar: :any,                 catalina:       "b83be4ad6fce30f484015b344d21e3e425860b3c8a2cb6a609e059611d03caf9"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "c68d8c7b9f5a4437ceb7697484a3609635d8b93fd24a37e1e7a5b973b8c2c9dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6052693231034f7a87a85eb4e56755786089171b9ce5ad1e0babe0a891af55d9"
  end

  head do
    url "https://github.com/mcabber/loudmouth.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkgconf" => :build
  depends_on "gettext"
  depends_on "glib"
  depends_on "gnutls"
  depends_on "libidn"

  uses_from_macos "krb5"

  def install
    system "./autogen.sh", "-n" if build.head?
    system "./configure", "--with-ssl=gnutls", *std_configure_args
    system "make"
    system "make", "check"
    system "make", "install"
    (pkgshare/"examples").install Dir["examples/*.c"]
  end

  test do
    cp pkgshare/"examples/lm-send-async.c", testpath
    system ENV.cc, "lm-send-async.c", "-o", "test",
      "-L#{lib}", "-L#{Formula["glib"].opt_lib}", "-lloudmouth-1", "-lglib-2.0",
      "-I#{include}/loudmouth-1.0",
      "-I#{Formula["glib"].opt_include}/glib-2.0",
      "-I#{Formula["glib"].opt_lib}/glib-2.0/include"
    system "./test", "--help"
  end
end
