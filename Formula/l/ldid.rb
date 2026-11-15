class Ldid < Formula
  desc "Lets you manipulate the signature block in a Mach-O binary"
  homepage "https://cydia.saurik.com/info/ldid/"
  url "git://git.saurik.com/ldid.git",
      tag:      "v2.1.5",
      revision: "a23f0faadd29ec00a6b7fb2498c3d15af15a7100"
  license "AGPL-3.0-or-later"
  revision 2
  head "git://git.saurik.com/ldid.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "7c8799de0bd1159299e337f15d28dc7e53b6e3d1bc2c6b4525b2acc31a250ee1"
    sha256 cellar: :any, arm64_tahoe:       "b1deffb6e575a4996e31cef6cbc56aa009f5eea67b73b437f6aea597198866a6"
    sha256 cellar: :any, arm64_sequoia:     "bafb40af217fc882cb89890b1c8ec8943d006369ad8736d5d2e6533c209b282b"
    sha256 cellar: :any, arm64_linux:       "28926ee4770d925d7d7d5712774169b5116b034ce42f2f81c3fff5005ef8d0dc"
    sha256 cellar: :any, x86_64_linux:      "dc1105c33e228c1afeecffc04094ad9fb24f092bfa8f6a774277930c6878340e"
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
