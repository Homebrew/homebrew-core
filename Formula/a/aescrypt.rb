class Aescrypt < Formula
  desc "Program for encryption/decryption"
  homepage "https://aescrypt.sourceforge.net/"
  url "https://aescrypt.sourceforge.net/aescrypt-0.7.tar.gz"
  sha256 "7b17656cbbd76700d313a1c36824a197dfb776cadcbf3a748da5ee3d0791b92d"
  license "BSD-4-Clause"

  livecheck do
    url :homepage
    regex(/href=.*?aescrypt[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "b4ec90c9ff44239c6cf43b35377e7ff709983c1b76577ea84cd8dbc638d763ee"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c7cb68631e925aa19e1e1c3cc513dab638b264b078d69a4033789e011876207b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6c6719bff5edd5e48eea46096d02b2818e94491901d419de070a0927fb53bd5d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bbd0fab48f97fd829f8fddf38423158d950668f84dfaee6d87f45fa1af96b55c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a6ca5e29be88eea7f2fe4faf1e57e3f827bfa86bae2726e5f83cedc79c091fcb"
    sha256 cellar: :any_skip_relocation, sonoma:         "156d8f92b0e60679fe57ab359c054ce6bc0345f519a69fa7184af5f6cd2ebdc5"
    sha256 cellar: :any_skip_relocation, ventura:        "436e60d661f966b478c730c3a0e9615a963e540424a6d9acf26f549d56bcd08a"
    sha256 cellar: :any_skip_relocation, monterey:       "a2d7637fcca0782a1f78089af50ea8a39d97d84f7e5fff9c9af938a353724887"
    sha256 cellar: :any_skip_relocation, big_sur:        "e41505ebcf2ca60292fd7391501ccc8d81ec41c96b23f2f50f21315bafc97f77"
    sha256 cellar: :any_skip_relocation, catalina:       "c5dac9eb7f3ce8509c766d82ef5f972c8a41984284ae3e01651c6f308164c5bd"
    sha256 cellar: :any_skip_relocation, mojave:         "55bc9c5be0263f1659ab389b22e1e5f594b037a87d49aa5ed94ab5ccce3af3da"
    sha256 cellar: :any_skip_relocation, high_sierra:    "1b2326e6dbc73d394cb5d4d7bf655b026fa77a7d66d02da386bff16b84e84d83"
    sha256 cellar: :any_skip_relocation, sierra:         "2250bd07f689721287269dc70c504b4f08ac2a02b5550ad9f0a51dca60ed6f9a"
    sha256 cellar: :any_skip_relocation, el_capitan:     "0cd940c7c9e59104746a8f83f92a06e703e7f98195a202d20516c03b588fd63f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2a2705c4423a86919b9309235a468b5cc1ac66200501bd255cefe0d26d1f07c6"
  end

  def install
    # Workaround for newer Clang
    ENV.append_to_cflags "-Wno-implicit-int" if DevelopmentTools.clang_build_version >= 1403

    # Work around failure from GCC 10+ using default of `-fno-common`
    # multiple definition of `ROUNDS'; aescrypt.o:(.bss+0x180): first defined here
    ENV.append_to_cflags "-fcommon" if OS.linux?

    system "./configure"
    system "make"
    bin.install "aescrypt", "aesget"
  end

  test do
    (testpath/"key").write "kk=12345678901234567890123456789abc0"
    original_text = "hello"
    cipher_text = pipe_output("#{bin}/aescrypt -k #{testpath}/key -s 128", original_text)
    deciphered_text = pipe_output("#{bin}/aesget -k #{testpath}/key -s 128", cipher_text)
    refute_equal original_text, cipher_text
    assert_equal original_text, deciphered_text
  end
end
