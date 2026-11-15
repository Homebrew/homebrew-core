class ActivemqCpp < Formula
  desc "C++ API for message brokers such as Apache ActiveMQ"
  homepage "https://activemq.apache.org/components/cms/"
  url "https://www.apache.org/dyn/closer.lua?path=activemq/activemq-cpp/3.9.5/activemq-cpp-library-3.9.5-src.tar.bz2"
  mirror "https://archive.apache.org/dist/activemq/activemq-cpp/3.9.5/activemq-cpp-library-3.9.5-src.tar.bz2"
  sha256 "6bd794818ae5b5567dbdaeb30f0508cc7d03808a4b04e0d24695b2501ba70c15"
  license "Apache-2.0"
  revision 2

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "6e323f753dd000afbbdc44da469b9fa7ce351c2dfa8eddaba51525570b11a972"
    sha256 cellar: :any, arm64_tahoe:       "9c9a911b431b088b643b759c0ae1a33e0ed6933671138960ba934dad44b32ad9"
    sha256 cellar: :any, arm64_sequoia:     "c2ffccf0fbcb9a47d9d9c3ed078bc26579d49e6aeeed67d9c521993d4de17bf8"
    sha256 cellar: :any, arm64_linux:       "dc3f782fb1c9048884d840a923ea68ea3bbf374685d63adc41b804817e20b40a"
    sha256 cellar: :any, x86_64_linux:      "d9b4c2ef7112a22d178a3e7e6ec339db26fa6036a64be65691d02dd088dc8c65"
  end

  depends_on "pkgconf" => :build
  depends_on "apr"
  depends_on "openssl@4"

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    file "Patches/libtool/configure-big_sur.diff"
    type :unofficial
  end

  # Backport commit which allows us to build with OpenSSL 4:
  # https://github.com/apache/activemq-cpp/commit/9c4df93026a777a86f9c886b538b454b4c32ba4e
  # This uses a local patch to drop README.txt and RPM spec diff that don't exist in tarball.
  patch :p2 do
    file "Patches/activemq-cpp/9c4df93026a777a86f9c886b538b454b4c32ba4e.diff"
    type :backport
  end

  deny_network_access!

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    system bin/"activemqcpp-config", "--version"
  end
end
