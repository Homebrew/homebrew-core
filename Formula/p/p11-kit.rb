class P11Kit < Formula
  desc "Library to load and enumerate PKCS#11 modules"
  homepage "https://p11-glue.freedesktop.org"
  url "https://github.com/p11-glue/p11-kit/releases/download/0.25.0/p11-kit-0.25.0.tar.xz"
  sha256 "d55583bcdde83d86579cabe3a8f7f2638675fef01d23cace733ff748fc354706"
  license "BSD-3-Clause"

  bottle do
    sha256 arm64_sonoma:   "d63c764955181159765918338c7c565ef0cf186db277666e3e09cb5c263ce214"
    sha256 arm64_ventura:  "4dad6178e4d9f6ac8d9e20036b8ec1163d2d46dff494d1911e6ffcd7b19a4f93"
    sha256 arm64_monterey: "d0263026b6e5f106d3edbfba4eb64ee0c8cf79a9230a016fb491191f2c7aeafc"
    sha256 arm64_big_sur:  "33bbe0d8e1741d7647ec4e192daeb3dbb7da9c0107b98114ea94bdefd2b32ba9"
    sha256 sonoma:         "1148b39149f4bf75fa0e3cd377549569c1f518c8ed2d6f001ea496636f1a957a"
    sha256 ventura:        "6fff2dfee52269c5ec53206c849cf25e06db85ccdd4790aae13032cb2e649b27"
    sha256 monterey:       "50c59d8c059b7d5cdc89dfe5d58f29ec5b0cba8a7cbe66be4686555666797a13"
    sha256 big_sur:        "20b049e0ef2eca9979dd94a210b46093ff6305c91535e89f74c42c6c1015cd06"
    sha256 x86_64_linux:   "7000de1b4a96605749dbc110b12f52b24227bd5900c3f32c1878eab75b0107d1"
  end

  head do
    url "https://github.com/p11-glue/p11-kit.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gettext" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "ca-certificates"
  depends_on "libtasn1"

  uses_from_macos "libffi", since: :catalina

  def install
    # https://bugs.freedesktop.org/show_bug.cgi?id=91602#c1
    ENV["FAKED_MODE"] = "1"

    if build.head?
      ENV["NOCONFIGURE"] = "1"
      system "./autogen.sh"
    end

    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}",
                          "--with-module-config=#{etc}/pkcs11/modules",
                          "--with-trust-paths=#{etc}/ca-certificates/cert.pem",
                          "--without-systemd"
    system "make"
    # This formula is used with crypto libraries, so let's run the test suite.
    system "make", "check"
    system "make", "install"
  end

  test do
    system "#{bin}/p11-kit", "list-modules"
  end
end
