class Cgit < Formula
  desc "Hyperfast web frontend for Git repositories written in C"
  homepage "https://git.zx2c4.com/cgit/"
  # Using git checkout as snapshot archives have previously changed from server updates
  # https://github.com/Homebrew/homebrew-core/pull/290649#issuecomment-5654421778
  url "https://git.zx2c4.com/cgit.git",
      tag:      "v1.3.1",
      revision: "044821677c774cd24f25f1818ea51d09cc64b006"
  license "GPL-2.0-only"

  livecheck do
    url "https://git.zx2c4.com/cgit/refs/tags"
    regex(/href=.*?cgit[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_golden_gate: "606c596e02fe6ed8940051bc9d7f4857908f2d93a5fd0f357302677df5b17512"
    sha256 arm64_tahoe:       "c89e460548f705e949484c9b1440fe1269314b6fcc809ca4f0533de2f12d096b"
    sha256 arm64_sequoia:     "8f18ed5941bb5b0efad997723f474a7c3ff04b481ac04e7f82fa25ec9cdb792c"
    sha256 arm64_sonoma:      "3c081f70e07173cc4ebc5fd905bea2f5145e59ea034c3ab25679fa30daf784c1"
    sha256 sonoma:            "1c3e21618c398df48955d3b0b7a8808f38386d4611d2c4c962424029b0e7a8ae"
    sha256 arm64_linux:       "f684c0282a8f001fd230bf3fc44fc5dc5e26da88babcc32be77ebd23cbd79180"
    sha256 x86_64_linux:      "3fc23bca0e145c1fa28489965871c6ad3f6f6c991c76bca4e7b99d68c1954fc1"
  end

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    depends_on "openssl@4" => :build # Uses CommonCrypto on macOS
    depends_on "zlib-ng-compat"
  end

  # cgit 1.2.2+ needs memrchr, for which macOS provides no implementation
  # https://lists.zx2c4.com/pipermail/cgit/2020-August/004510.html
  patch do
    file "Patches/cgit/memrchr-impl.patch"
  end

  def install
    system "make", "prefix=#{prefix}",
                   "CGIT_SCRIPT_PATH=#{pkgshare}",
                   "CGIT_DATA_PATH=#{var}/www/htdocs/cgit",
                   "CGIT_CONFIG=#{etc}/cgitrc",
                   "CACHE_ROOT=#{var}/cache/cgit",
                   "install"
  end

  test do
    (testpath/"cgitrc").write <<~EOS
      repo.url=test
      repo.path=#{testpath}
      repo.desc=the master foo repository
      repo.owner=fooman@example.com
    EOS

    ENV["CGIT_CONFIG"] = testpath/"cgitrc"
    # no "Status" line means 200
    refute_match(/Status: .+/, shell_output("#{pkgshare}/cgit.cgi"))
  end
end
