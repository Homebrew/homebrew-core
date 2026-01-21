class Mksh < Formula
  desc "MirBSD Korn Shell"
  homepage "https://mbsd.evolvis.org/mksh.htm"
  url "https://mbsd.evolvis.org/MirOS/dist/mir/mksh/mksh-R59c.tgz"
  version "59c"
  sha256 "77ae1665a337f1c48c61d6b961db3e52119b38e58884d1c89684af31f87bc506"
  license "MirOS"

  livecheck do
    url "https://mbsd.evolvis.org/MirOS/dist/mir/mksh/"
    regex(/href=.*?mksh-R?(\d+[a-z]?)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "99d5701b22abd93460ac4d8dff1779534e5a74ccb010f96091a70bc7499ec464"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "b4a7e852c89de699dd93d9e89d5c6928b416f3fc5c54211dc2cb00188d228b66"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "be279888c13fec0c586f14251a00d0413a0bc835dadc07ca0c2f648c5d0b13a5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7f8fa2427f871cd4e4e7143244f5862988cb72e0a264c0b947c4f2f72d3655d8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c9467abce8ddfd5d5dbdfda62ab8b36d020c92ae4c06805ecafd9973e20f4307"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4e5b153d2643f455c5be25fa8f751eed863393b454abc3df8bb9b145799152e0"
    sha256 cellar: :any_skip_relocation, sonoma:         "b207ba72de0409491e51887f2660ffd299f773af5111326d367380ba5a508fb4"
    sha256 cellar: :any_skip_relocation, ventura:        "410441bef1f6b4cbe36c35ec7fad198fcdbeae06a37e65c4a95471dcaa52bf26"
    sha256 cellar: :any_skip_relocation, monterey:       "df3d31ae543c8f8008eba65b86ac9090f21ca2f365df41e0c9984f93f1372df0"
    sha256 cellar: :any_skip_relocation, big_sur:        "879b0a3185d7cb75235a3204cba1b66e7353b77458b63deef3c7635e75f52ba4"
    sha256 cellar: :any_skip_relocation, catalina:       "ab6ffddb634219464c5993a9109a051fa728f217b7c89daa95d5b85748127bf5"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "84fbeb841b6f1cdeb5b8e68daa1b4a4fd72fb689b9a6f597bf9e886e01d3d08f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c371844df8480e29acc7a3f4096944880b9652a4490d0036f6f845b4c6c3d8be"
  end

  def install
    system "sh", "./Build.sh", "-r"
    bin.install "mksh"
    man1.install "mksh.1"
  end

  test do
    assert_equal "honk",
      shell_output("#{bin}/mksh -c 'echo honk'").chomp
  end
end
