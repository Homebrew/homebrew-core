class Fprobe < Formula
  desc "Libpcap-based NetFlow probe"
  homepage "https://sourceforge.net/projects/fprobe/"
  url "https://downloads.sourceforge.net/project/fprobe/fprobe/1.1/fprobe-1.1.tar.bz2"
  sha256 "3a1cedf5e7b0d36c648aa90914fa71a158c6743ecf74a38f4850afbac57d22a0"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fc681a6b0978ce9f02ba8004055f444567398e689b8f453d2061f6f2f20d3bd3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "166c831373d123030545fa69b5fabbb0124fa9501ac1258e43c81a1b00222a1a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "83c78c439cf2ec7338b3033e9cd623d04f8d19064ad566d206fc290d375f5472"
    sha256 cellar: :any_skip_relocation, ventura:        "cb2e30b70d2d6c74bf835841fe85df84c2465e562e573985567f29bc61ec6b6d"
    sha256 cellar: :any_skip_relocation, monterey:       "61a41b0da60f8b3a285216e847d25c25d95e457cb3da9c8f63bdfdaae4f8b8ae"
    sha256 cellar: :any_skip_relocation, big_sur:        "b0a00f4b300f319155db2ce5c159dd5731147380cb4b21cdd001e7b519d132b2"
    sha256 cellar: :any_skip_relocation, catalina:       "4684922307e7da6edc51c66f9ff647cf1d6b44bb75ab15deb4ea76629c8cbf2e"
    sha256 cellar: :any_skip_relocation, mojave:         "7867a9b5dc5014263723f471156464a641962249380494e4732785bafb7afeb2"
    sha256 cellar: :any_skip_relocation, high_sierra:    "31efd46250371cfd9ab386ff34cc41eb98d10758d550769ec72f8373ac1df800"
    sha256 cellar: :any_skip_relocation, sierra:         "fe38758d956c43b2a223734d426c990c63ee44ac643dc769c3d6a0cd4f07ef6b"
    sha256 cellar: :any_skip_relocation, el_capitan:     "9b06507a358024842b59c9f4d637b94b3681e720dbd3a1a8bc93d4d34f9a4442"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e295fddc95d80d87b222455cca00e95aa3a429317c08daeee456aac1f3170732"
  end

  uses_from_macos "libpcap"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--mandir=#{man}",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match "NetFlow", shell_output("#{sbin}/fprobe -h").strip
  end
end
