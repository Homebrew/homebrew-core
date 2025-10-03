class Plowshare < Formula
  desc "Download/upload tool for popular file sharing websites"
  homepage "https://github.com/mcrapet/plowshare"
  url "https://github.com/mcrapet/plowshare/archive/refs/tags/v2.1.7.tar.gz"
  sha256 "c17d0cc1b3323f72b2c1a5b183a9fcef04e8bfc53c9679a4e1523642310d22ad"
  license "GPL-3.0-or-later"
  revision 1

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "1010ee8073ce51f2450ac66e60978f6a5a3f7f0a48b9a0239e66b792a089d17b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "9a2dcee44e65269a88332c733ecf4e8f6be114bb689283bfcdf35e091792902d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f580fd10b96117f7860b8c4bdd970f1d82f3f276b625a5960b2865801391dfbd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "861153a64f192c3e5ba25f43e59d5b3d8a96064cfb422b4d7a76986f96a4699d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0fdf55cf9624e4d8a9abfd52b93db4edb8540082d2ddad5bdee597612862aca0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d5552280803160034db82652d6eb8fa9ead72d8bd4c9be2c0e03c9b6ee2a897c"
    sha256 cellar: :any_skip_relocation, sonoma:         "d8a4b138d04f914d64ac46493274c001f7fcaa90e15fc99fde7041b770fa001e"
    sha256 cellar: :any_skip_relocation, ventura:        "459e03bc4ae1b5474cb45ede0e4cf578ac07e09ddf53ef5576a4d8565727f25c"
    sha256 cellar: :any_skip_relocation, monterey:       "9ee2632cc598eab9744d758e037c8a0eecc202c19e93ed01670bdefecb6ba00a"
    sha256 cellar: :any_skip_relocation, big_sur:        "3d995918e629820f93c9a6d9e2661c4182ba181d2959306adbbfea1b24af5498"
    sha256 cellar: :any_skip_relocation, catalina:       "71fc52474893fbb6b7d0a9644ea1a368a59f91fb59c946052a060a10e493157b"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "5afc0b7489b2da73229e12e21b35824f4eaa61e648f7eabc564872c95faedb1c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d5b299d87fbdd4deb61521da33c68f81bed370130a2ecaa3565d059055f315d8"
  end

  depends_on "bash"
  depends_on "feh"
  depends_on "libcaca"
  depends_on "recode"
  depends_on "spidermonkey"

  on_macos do
    depends_on "coreutils"
    depends_on "gnu-sed"
  end

  def install
    sed_args = OS.mac? ? ["patch_gnused", "GNU_SED=#{Formula["gnu-sed"].opt_bin}/gsed"] : []
    system "make", "install", *sed_args, "PREFIX=#{prefix}"
  end

  test do
    output = shell_output("#{bin}/plowlist 2>&1", 15)
    assert_match "no folder URL specified!", output
  end
end
