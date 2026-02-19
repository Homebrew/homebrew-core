class Fprobe < Formula
  desc "Libpcap-based NetFlow probe"
  homepage "https://sourceforge.net/projects/fprobe/"
  url "https://downloads.sourceforge.net/project/fprobe/fprobe/1.1/fprobe-1.1.tar.bz2"
  sha256 "3a1cedf5e7b0d36c648aa90914fa71a158c6743ecf74a38f4850afbac57d22a0"
  license "GPL-2.0-only"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "4cbf791e6fc38eca3bf5be7634eedee0a1b970783f0f1516227838541d708b47"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "edcd1f7fb0c159ed2363136b500af38948c8e4a9a1cb26b4b3c6e745f2ef67c4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8bdcb6faba3511a0868787da0e4baeb9219e9862c0323722d6137473ac81d0f8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fc681a6b0978ce9f02ba8004055f444567398e689b8f453d2061f6f2f20d3bd3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "166c831373d123030545fa69b5fabbb0124fa9501ac1258e43c81a1b00222a1a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "83c78c439cf2ec7338b3033e9cd623d04f8d19064ad566d206fc290d375f5472"
    sha256 cellar: :any_skip_relocation, sonoma:         "ff966a798c134ba1c15e224e5aa6803ce478dc0bf733b332e6f57c2fdbe1a20f"
    sha256 cellar: :any_skip_relocation, ventura:        "cb2e30b70d2d6c74bf835841fe85df84c2465e562e573985567f29bc61ec6b6d"
    sha256 cellar: :any_skip_relocation, monterey:       "61a41b0da60f8b3a285216e847d25c25d95e457cb3da9c8f63bdfdaae4f8b8ae"
    sha256 cellar: :any_skip_relocation, big_sur:        "b0a00f4b300f319155db2ce5c159dd5731147380cb4b21cdd001e7b519d132b2"
    sha256 cellar: :any_skip_relocation, catalina:       "4684922307e7da6edc51c66f9ff647cf1d6b44bb75ab15deb4ea76629c8cbf2e"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "437bdecb9e1ca25e8791a4bb7408f128b11ab7b14267913a1ba106dd0dc6635d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e295fddc95d80d87b222455cca00e95aa3a429317c08daeee456aac1f3170732"
  end

  uses_from_macos "libpcap"

  def install
    args = []
    # Help old config scripts identify arm64 linux
    args << "--build=aarch64-unknown-linux-gnu" if OS.linux? && Hardware::CPU.arm? && Hardware::CPU.is_64_bit?

    system "./configure", "--disable-silent-rules", "--mandir=#{man}", *args, *std_configure_args
    system "make", "install"
  end

  test do
    assert_match "NetFlow", shell_output("#{sbin}/fprobe -h").strip
  end
end
