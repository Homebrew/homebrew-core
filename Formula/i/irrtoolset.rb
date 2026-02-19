class Irrtoolset < Formula
  desc "Tools to work with Internet routing policies"
  homepage "https://github.com/irrtoolset/irrtoolset"
  url "https://github.com/irrtoolset/irrtoolset/archive/refs/tags/release-5.1.3.tar.gz"
  sha256 "a3eff14c2574f21be5b83302549d1582e509222d05f7dd8e5b68032ff6f5874a"
  license all_of: ["MIT", "HPND", "GPL-2.0-or-later", "LGPL-2.0-or-later"]
  head "https://github.com/irrtoolset/irrtoolset.git", branch: "master"

  livecheck do
    url :stable
    regex(/v?(\d+(?:[._-]\d+)+)/i)
    strategy :github_latest
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "eb7536136362e5471a79b098bbe9004b69696ec161b68e89f4e5fae18a1ad2ec"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "c8f841c2b1f1181dfd110bb27a4d374ff43d204bda34a871aa260bd8c67c7e43"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "89d7ae76431629fd7703e8295dae62fbaae4ef6adba8b261e14d92ff409fc450"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5834b05bb5b3280a60032cca1d759d1ffd7f513118fdabe5e9ded8c7d08252de"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "435c4b7b2a17d32046afab709f58dad5ce6b4372a064223eb9b695e939df097c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "545814a389476ca20bd0419777b6d82a17a47e0e695d5bbac3ffcb8406c50c47"
    sha256 cellar: :any_skip_relocation, sonoma:         "75c7f0f0b7f2c2173740961a9bb2cce8b77456bbcce1343672169ad392c929a3"
    sha256 cellar: :any_skip_relocation, ventura:        "11e52bef1dfd00a4986b2569907a6cd813f48805273de424006bd54d939d6b38"
    sha256 cellar: :any_skip_relocation, monterey:       "0a1e66582bd543ecde2c8429c3cfbe9254fc9e55056ffc519d56a89f7b1b22e1"
    sha256 cellar: :any_skip_relocation, big_sur:        "632c6b4036c71036b6b4038816dd20a3f791e9d06aab981f01429fc07bb4d3a3"
    sha256 cellar: :any_skip_relocation, catalina:       "958df309df54264b13dba2185761e5d4ce1397e3c6b079dbd9396e054d02d306"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "764470b02f51abbb9c5a21cb574bb11b226213478829953fd5d115b45e6e1f46"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b03e7fcf28c8481e33209b35b08bac6d1293240ea1f7d71714c3bce19ee98b88"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "bison" => :build # Uses newer syntax than system Bison supports
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build

  uses_from_macos "flex" => :build

  on_linux do
    depends_on "readline"
  end

  def install
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system bin/"peval", "ANY"
  end
end
