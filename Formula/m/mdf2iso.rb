class Mdf2iso < Formula
  desc "Tool to convert MDF (Alcohol 120% images) images to ISO images"
  homepage "https://packages.debian.org/sid/mdf2iso"
  url "https://deb.debian.org/debian/pool/main/m/mdf2iso/mdf2iso_0.3.1.orig.tar.gz"
  sha256 "906f0583cb3d36c4d862da23837eebaaaa74033c6b0b6961f2475b946a71feb7"
  license "GPL-2.0-or-later"

  livecheck do
    skip "No longer developed or maintained"
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "0c648a8e13264b77de5d985cc394c4987d48b5acd55f32e8a3f1fc15a2585504"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "cb7698f54dab58995f190cb1fa0b27206fdcc26df54ed14340042bbdf5e9bc22"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e6fe3b6e39dc1c0edc7258d2a36af055d21aba09074adb99f427a1c18f7e5fb1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7dad8470649a9874ce6321736a6a14d4a76cd2ea1ca5c379cadf10da1ab45c8b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7952ed81c8034b504bb0e55e147e2f601990494b35cfe1fea3ba3c2cd006bb0c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7f37a97303ac1ff9388377bc91cf1e7f278e94f1245d38f96dc19a3b81c81f76"
    sha256 cellar: :any_skip_relocation, sonoma:         "a3b321e6ef2421a75ea98cae15bf983886dc0024b6f12a0be3deca4beedf954f"
    sha256 cellar: :any_skip_relocation, ventura:        "143253bf20f183053fa47c7f6ea2a4fe0e93b218d86066f820f84004257502f8"
    sha256 cellar: :any_skip_relocation, monterey:       "60af1882c7912a64f4c1c79bf5fa6e59c0d1f01d8fc93e29cde28e3d564bf093"
    sha256 cellar: :any_skip_relocation, big_sur:        "204334f29ddd79b10b91e2d844e2d20507f315fb4d39109dcfbe7747b3fbf64d"
    sha256 cellar: :any_skip_relocation, catalina:       "ac57f5ffc3e1ac884d74b08dddce518e60f878e627cbfccc7dcb4642c5eb0653"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "d4e0fcb1b65f5e0680c63e7d4dd2c481315d5879876ba4a6cd0ea1ea5d8bea4f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5a24e6b2c8771e9f5119bc4baa9bb8da4570df954d44782ba43e6b5c6f7e6a3a"
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mdf2iso --help")
  end
end
