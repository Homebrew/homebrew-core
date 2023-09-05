class Ldid < Formula
  desc "Lets you manipulate the signature block in a Mach-O binary"
  homepage "https://cydia.saurik.com/info/ldid/"
  url "https://git.saurik.com/ldid.git",
      tag:      "v2.1.5",
      revision: "a23f0faadd29ec00a6b7fb2498c3d15af15a7100"
  license "AGPL-3.0-or-later"
  head "https://git.saurik.com/ldid.git", branch: "master"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "de5309e94aa8b3d89a5fc491303ba085f1447e78dfc5faf3b33b3ea5924a26ce"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "46638da20907c85a843694387ebff5a5519efb954073f6d2c516ab24ab75b0a2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cc9883ac2ba363d2b4a2d95cc473be36d856ab84fad1251ecbaaa95b976f98c9"
    sha256 cellar: :any_skip_relocation, ventura:        "80abfac117205b631eec200775430181265f811d33b559e3d51608e19894f4ba"
    sha256 cellar: :any_skip_relocation, monterey:       "238070b4a07e3a2606620266d870be97193e60c34224e3056a40288efaf589a1"
    sha256 cellar: :any_skip_relocation, big_sur:        "1d1c195538de1b21aed193e94866f82951b3ad99226d0b6e4a9852af09fec35e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eba4a8deb51016607b6fdc681c2bb9168e294f83d098f6c25a76b1c66d3be803"
  end

  depends_on "libplist"
  depends_on "openssl@3"
  uses_from_macos "libxml2"

  conflicts_with "ldid-procursus", because: "ldid-proucursus installs a conflicting ldid binary"

  def install
    ENV.append_to_cflags "-I."
    ENV.append "CXXFLAGS", "-std=c++11"
    linker_flags = %w[lookup2.o -lcrypto -lplist-2.0 -lxml2]
    linker_flags += %w[-framework CoreFoundation -framework Security] if OS.mac?

    system "make", "lookup2.o"
    system "make", "ldid", "LDLIBS=#{linker_flags.join(" ")}"

    bin.install "ldid"
    bin.install_symlink "ldid" => "ldid2"
  end

  test do
    cp test_fixtures("mach/a.out"), testpath
    system bin/"ldid", "-S", "a.out"
  end
end
