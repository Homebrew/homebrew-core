class Mpop < Formula
  desc "POP3 client"
  homepage "https://marlam.de/mpop/"
  url "https://marlam.de/mpop/releases/mpop-1.2.8.tar.xz"
  sha256 "16c3794507673bb1e6e8a9231787594155f32e5c68a901368045cf458f6a79ea"

  bottle do
    cellar :any
    sha256 "bfb202f660cc7e79f8e58ba853ca3afe1ae4d205cb84301401bdc035336849bd" => :high_sierra
    sha256 "09f173b7d63bedd36901aef8243c8544d3b937d825084396ba1f999f6d029944" => :sierra
    sha256 "883ed0da7dab681c86709fa7f6dec1528ea579fcfe889bbb87e6834cac9617e3" => :el_capitan
    sha256 "a15f133e343b6a315c9236f4a5def960936f4e9a326efc30c438fdf2fd46c2a2" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "openssl"

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mpop --version")
  end
end
