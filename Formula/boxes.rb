class Boxes < Formula
  desc "Draw boxes around text"
  homepage "https://boxes.thomasjensen.com/"
  url "https://github.com/ascii-boxes/boxes/archive/v2.2.0.tar.gz"
  sha256 "98b8e3cf5008f46f096d5775d129c34db9f718728bffb0f5d67ae89bb494102e"
  license "GPL-3.0-only"
  head "https://github.com/ascii-boxes/boxes.git", branch: "master"

  bottle do
    sha256 arm64_monterey: "23f81e330d74582785d6b6aca4900c10487d8cae733f5caf4944c484f93eb3e4"
    sha256 arm64_big_sur:  "79e09ade59fd7db22de7f3160edbb03375290d25b1d16c1225cbd310cf30dc73"
    sha256 monterey:       "dcd22b8872dde84938d31c7b373ebc6f139d6af2a1823d9954e097651a28daf5"
    sha256 big_sur:        "43acc18d20ea9bc0cb30e4ed6498071763da130a2b91f0afff9c2f181eb6b814"
    sha256 catalina:       "deb00c1a1a555dbae43cea3a45959902cba8a50cc261a88e8c5808c7042bbb19"
    sha256 x86_64_linux:   "581f765f9c4d78d0ae2d507c45b4d931e6cbee06f637504eba9fb8e0f450804d"
  end

  depends_on "bison" => :build
  depends_on "libunistring"
  depends_on "pcre2"

  uses_from_macos "flex" => :build

  def install
    # distro uses /usr/share/boxes change to prefix
    system "make", "GLOBALCONF=#{share}/boxes-config",
                   "CC=#{ENV.cc}",
                   "YACC=#{Formula["bison"].opt_bin/"bison"}"

    bin.install "out/boxes"
    man1.install "doc/boxes.1"
    share.install "boxes-config"
  end

  test do
    assert_match "test brew", pipe_output("#{bin}/boxes", "test brew")
  end
end
