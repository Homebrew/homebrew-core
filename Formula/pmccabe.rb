class Pmccabe < Formula
  desc "Calculate McCabe-style cyclomatic complexity for C/C++ code"
  homepage "https://packages.debian.org/sid/pmccabe"
  url "https://deb.debian.org/debian/pool/main/p/pmccabe/pmccabe_2.6.tar.gz"
  sha256 "e490fe7c9368fec3613326265dd44563dc47182d142f579a40eca0e5d20a7028"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "c9509bbb9d642f0245364a542f5b89dded2101968358d352e892564371f1ffd4" => :catalina
    sha256 "660ae3ce966863082ba287ba9e52c0772c41e1d58571e02c3d898b71ac4682a5" => :mojave
    sha256 "054dd89d0934715b169875d8d0bcce39db919550752eab9cadc083eab0e148cf" => :high_sierra
    sha256 "220285c0f0ae07835785574504d1d7730fb2abc06ddacfb76e1fe73f999d2cc1" => :sierra
    sha256 "d6189f6ae7341da933653c687adec0bb8952b14ed8a2883b19aec4db90b65eea" => :el_capitan
    sha256 "cb369d2f04ce0fccdb22b2640f1f6e37fc056b6edda79767474040cb52f76936" => :yosemite
    sha256 "d64603cace1f97227e6efc2c26f628fece4e49f762e1e6d0903400a579be0a0f" => :mavericks
  end

  def install
    ENV.append_to_cflags "-D__unix"

    system "make"
    bin.install "pmccabe", "codechanges", "decomment", "vifn"
    man1.install Dir["*.1"]
  end

  test do
    assert_match /pmccabe #{version}/, shell_output("#{bin}/pmccabe -V")
  end
end
