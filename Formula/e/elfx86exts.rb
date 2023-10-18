class Elfx86exts < Formula
  desc "Decodes x86 binaries (ELF and Mach-O) and prints out ISA extensions in use"
  homepage "https://github.com/pkgw/elfx86exts"
  url "https://github.com/pkgw/elfx86exts/archive/refs/tags/elfx86exts@0.6.0.tar.gz"
  sha256 "976f845635f08160c1330f3e70fd9b61bafbc26c76577bd278a7f2e8513d4130"
  license "MIT"
  head "https://github.com/pkgw/elfx86exts.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(?:elfx86exts@)?v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c716057d907972efaeca5bea46c37b55cab430c1bc137ad0e13598824c0c9d82"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5a0554a17a80005a128712f2d36bf76937e6fe8c6e251924df4675d1d254826e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "814b6a9eafe0ba01113f321ff3422b0a0b548ced73990f0bcd1536a892b93e88"
    sha256 cellar: :any_skip_relocation, sonoma:         "49652af634ddcdc92910dfa7b5ce9732d96e1314285b3263247c49721da35db3"
    sha256 cellar: :any_skip_relocation, ventura:        "53ae0ee4d79ac9da52afd2889ac36e8b2dae183b99445d3b0d6f2ab8abef155f"
    sha256 cellar: :any_skip_relocation, monterey:       "afd45d57a6586a7c6551a5e8e64bce951672aba684066e2eb0136077410b88e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7e3a46896ba36346c6338838c2380ccb3cdf26c23cb796bbe95d3a7bf95434b5"
  end

  depends_on "rust" => :build
  depends_on "capstone"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    expected = <<~EOS
      File format and CPU architecture: Elf, X86_64
      MODE64 (call)
      Instruction set extensions used: MODE64
      CPU Generation: Intel Core
    EOS
    actual = shell_output("#{bin}/elfx86exts #{test_fixtures("elf/hello")}")
    assert_equal expected, actual
  end
end
