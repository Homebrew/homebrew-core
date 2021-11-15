class Pmccabe < Formula
  desc "Calculate McCabe-style cyclomatic complexity for C/C++ code"
  homepage "https://packages.debian.org/sid/pmccabe"
  url "https://deb.debian.org/debian/pool/main/p/pmccabe/pmccabe_2.6.tar.gz"
  sha256 "e490fe7c9368fec3613326265dd44563dc47182d142f579a40eca0e5d20a7028"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c6c88c18e4ab09022443c5c453c16e4651544bd54b8ce834a56c4ba6ce6acd6b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4005a28868925656ae168641a19420ae289c20fc1abc18c0fcc2a1e8c1da852a"
    sha256 cellar: :any_skip_relocation, monterey:       "8dac04a30e041c7f1fc5d34a0e438611867cadfa5fdfd7d343703fe1e212dd52"
    sha256 cellar: :any_skip_relocation, big_sur:        "ad983fc804edcd046eb600ecaf10901ce1450490c4da869989aa973dae0415d5"
    sha256 cellar: :any_skip_relocation, catalina:       "c9509bbb9d642f0245364a542f5b89dded2101968358d352e892564371f1ffd4"
    sha256 cellar: :any_skip_relocation, mojave:         "660ae3ce966863082ba287ba9e52c0772c41e1d58571e02c3d898b71ac4682a5"
    sha256 cellar: :any_skip_relocation, high_sierra:    "054dd89d0934715b169875d8d0bcce39db919550752eab9cadc083eab0e148cf"
    sha256 cellar: :any_skip_relocation, sierra:         "220285c0f0ae07835785574504d1d7730fb2abc06ddacfb76e1fe73f999d2cc1"
    sha256 cellar: :any_skip_relocation, el_capitan:     "d6189f6ae7341da933653c687adec0bb8952b14ed8a2883b19aec4db90b65eea"
    sha256 cellar: :any_skip_relocation, yosemite:       "cb369d2f04ce0fccdb22b2640f1f6e37fc056b6edda79767474040cb52f76936"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9030ba3aa954a0a0ed5a93b2b660d49651a50fce1091009aa497dafd5324486b"
  end

  def install
    ENV.append_to_cflags "-D__unix"

    system "make"
    bin.install "pmccabe", "codechanges", "decomment", "vifn"
    man1.install Dir["*.1"]
  end

  test do
    assert_match "pmccabe #{version}", shell_output("#{bin}/pmccabe -V")
  end
end
