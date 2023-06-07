class Libidn < Formula
  desc "International domain name library"
  homepage "https://www.gnu.org/software/libidn/"
  url "https://ftp.gnu.org/gnu/libidn/libidn-1.41.tar.gz"
  mirror "https://ftpmirror.gnu.org/libidn/libidn-1.41.tar.gz"
  sha256 "884d706364b81abdd17bee9686d8ff2ae7431c5a14651047c68adf8b31fd8945"
  license any_of: ["GPL-2.0-or-later", "LGPL-3.0-or-later"]

  bottle do
    sha256 cellar: :any, arm64_ventura:  "9b6d7f6616a31a56829e53ed6ff8c7491f0a076afdf9ec25d3cccd3701b83b0a"
    sha256 cellar: :any, arm64_monterey: "c4a1c32197a17b25f61adecc077503661b595efa986d9c418e9a736354eee3e1"
    sha256 cellar: :any, arm64_big_sur:  "2c1ec1cc41cb3ca506930d50367fcdcabee872156c8c4ae44ac68ae022cd5d41"
    sha256 cellar: :any, ventura:        "d1eac4ba5398dc47ffb3ba9931f71590a487b1847f146cdd615026a184304ca6"
    sha256 cellar: :any, monterey:       "ad84e01ad371a8bd47a15a2b2da2acef55293cc6fc72ef0e5130986ddfd119c7"
    sha256 cellar: :any, big_sur:        "464812fe81d7bafe7c25fe5d4e7348b603e5ded35410ff52b9933db76e6e5724"
    sha256 cellar: :any, catalina:       "9e6ed6c2ea5ad341d3e0627ee67861001bb8104f441298b456b983e935d5aa55"
    sha256               x86_64_linux:   "fe9a04089d251cc404385029ab855630c509961937930cb703ff85b236503751"
  end

  depends_on "pkg-config" => :build

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-csharp",
                          "--with-lispdir=#{elisp}"
    system "make", "install"
  end

  test do
    ENV["CHARSET"] = "UTF-8"
    system bin/"idn", "räksmörgås.se", "blåbærgrød.no"
  end
end
