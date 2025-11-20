class Ldid < Formula
  desc "Lets you manipulate the signature block in a Mach-O binary"
  homepage "https://cydia.saurik.com/info/ldid/"
  url "git://git.saurik.com/ldid.git",
      tag:      "v2.1.5",
      revision: "a23f0faadd29ec00a6b7fb2498c3d15af15a7100"
  license "AGPL-3.0-or-later"
  revision 1
  head "git://git.saurik.com/ldid.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "4c28297c1094cde3ae7fe7061400807d8936b9d0fb9fc317a354ce7cd856bf33"
    sha256 cellar: :any,                 arm64_sequoia: "1aa932cfbef34182e232838733a904cd0f3579ea04f5593de9611afaff5e19e3"
    sha256 cellar: :any,                 arm64_sonoma:  "63d9fa30a42dadd7fc7ca9d171d34b73159a082ab37dfb0cb8bd713388e8820a"
    sha256 cellar: :any,                 sonoma:        "b60a204f73db3794d0cba7d85ec6318bb29050e69cd705a4e9ac540ef395cac1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c406cbaf506a024df5d668b9fba39c5a776a28ad3601b34a89c445894fa7b646"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b8a69a0616a8dda110f61623b22635142b61d1cf611e60f17a70b336a1df20e6"
  end

  depends_on "libplist"
  depends_on "openssl@3"

  conflicts_with "ldid-procursus", because: "ldid-proucursus installs a conflicting ldid binary"

  def install
    ENV.append_to_cflags "-I."
    ENV.append "CXXFLAGS", "-std=c++11"
    linker_flags = %w[lookup2.o -lcrypto -lplist-2.0]

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
