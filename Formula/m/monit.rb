class Monit < Formula
  desc "Manage and monitor processes, files, directories, and devices"
  homepage "https://mmonit.com/monit/"
  url "https://mmonit.com/monit/dist/monit-5.34.4.tar.gz"
  sha256 "ef607cfaabfd3767d40b9b9e32032f748beebc4d686831f6111e0e68fbd1b469"
  license "AGPL-3.0-or-later"

  livecheck do
    url "https://mmonit.com/monit/dist/"
    regex(/href=.*?monit[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "45c8e33967d63464d0fc1a303a99cca51ec505d50973421ca8a25bf864d1d131"
    sha256 cellar: :any,                 arm64_sonoma:  "43f559f52994cd676c7ad6c6db73bb6c32c71e016d6022ddfe564251c8aabb5c"
    sha256 cellar: :any,                 arm64_ventura: "b9085185857fcba7fd28b284c57b0f8cf5c26e321fa9d8b635b380fe82444d41"
    sha256 cellar: :any,                 sonoma:        "6bc6afa5aa1226ba246f97e48f0f6aaeccb59b212447ce324f8bc3131699d56f"
    sha256 cellar: :any,                 ventura:       "0dde553c672aefd0e8161b94ad4967b2ddf4034bcd416693b9f341021c3e2821"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "15257eac795a5b31142356b36d13e8d2bbb1dd8acba5831d2d5dde5761a62c57"
  end

  depends_on "openssl@3"

  uses_from_macos "libxcrypt"
  uses_from_macos "zlib"

  on_linux do
    depends_on "linux-pam"
  end

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--localstatedir=#{var}/monit",
                          "--sysconfdir=#{etc}/monit",
                          "--with-ssl-dir=#{Formula["openssl@3"].opt_prefix}"
    system "make"
    system "make", "install"
    etc.install "monitrc"
  end

  service do
    run [opt_bin/"monit", "-I", "-c", etc/"monitrc"]
  end

  test do
    system bin/"monit", "-c", "#{etc}/monitrc", "-t"
  end
end
