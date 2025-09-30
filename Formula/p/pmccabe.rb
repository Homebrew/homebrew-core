class Pmccabe < Formula
  desc "Calculate McCabe-style cyclomatic complexity for C/C++ code"
  homepage "https://gitlab.com/pmccabe/pmccabe"
  url "https://gitlab.com/pmccabe/pmccabe/-/archive/v2.8/pmccabe-v2.8.tar.bz2"
  sha256 "d37cafadfb64507c32d75297193f99f1afcf12289b7fcc1ddde4a852f0f2ac8a"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:[._]\d+)+[a-z]?)$/i)
    strategy :git do |tags, regex|
      tags.map { |tag| tag[regex, 1]&.tr("_", ".") }
    end
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "d6009f8f139c0e42442a816ca33c1bfdfc37139431948350fdc107d35d24c7cf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "0e638bf96079e2650e33e91114ab8b2559fbc1d9b998e6afa5eae06a6e1d4eca"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "910d1bd786def57f3f61e080e1d8918f8dbebd42d0474fd273c93949b169d154"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3f712276e9c471ef5ebb6de8c2849ca16372b9a5328e742c3c63a23b3106b84d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8c6016e6ab56ccce1d1582831e05a5f4d66650b7668a83fe8a73047badfc8dd3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e0510e85fcc8a8420a603b7d49ceb3e13e564f232092bd9c585e1917fb5433a9"
    sha256 cellar: :any_skip_relocation, sonoma:         "cd57edd23101b3dfef261c1a490f465631ba19486d4f18ea25bab760d18de972"
    sha256 cellar: :any_skip_relocation, ventura:        "532ca4f8afb763ea7cb3b1b5e657df66657ceac9d5d62ae3c91c142419c36e91"
    sha256 cellar: :any_skip_relocation, monterey:       "c2c173eb072bf9df7e1a17ab8293ca29739df8fc4432aa6d3441b600d693159e"
    sha256 cellar: :any_skip_relocation, big_sur:        "dde2bd06ac574cfa68f4f4f095fa09b3e9ed6a2656748d333aaa19fb09d81820"
    sha256 cellar: :any_skip_relocation, catalina:       "61595681c5b5a9a8b22b83728e2ee89d5280b5e970c3f6e93aee438fe763f93f"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "cdd2686801fae30006c4e4b28c937caa03fd01773b05c60c1c3900a90d4242fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "90f8e8df8eab3561f9a8a91438cb4903395dda9d18d3f61daece3cd5f58445da"
  end

  def install
    ENV.append_to_cflags "-D__unix"

    system "make", "CFLAGS=#{ENV.cflags}"
    bin.install "pmccabe", "codechanges", "decomment", "vifn"
    man1.install Dir["*.1"]
  end

  test do
    assert_match "pmccabe #{version}", shell_output("#{bin}/pmccabe -V")
  end
end
