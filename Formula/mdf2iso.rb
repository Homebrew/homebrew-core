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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7dad8470649a9874ce6321736a6a14d4a76cd2ea1ca5c379cadf10da1ab45c8b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7952ed81c8034b504bb0e55e147e2f601990494b35cfe1fea3ba3c2cd006bb0c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7f37a97303ac1ff9388377bc91cf1e7f278e94f1245d38f96dc19a3b81c81f76"
    sha256 cellar: :any_skip_relocation, ventura:        "143253bf20f183053fa47c7f6ea2a4fe0e93b218d86066f820f84004257502f8"
    sha256 cellar: :any_skip_relocation, monterey:       "60af1882c7912a64f4c1c79bf5fa6e59c0d1f01d8fc93e29cde28e3d564bf093"
    sha256 cellar: :any_skip_relocation, big_sur:        "204334f29ddd79b10b91e2d844e2d20507f315fb4d39109dcfbe7747b3fbf64d"
    sha256 cellar: :any_skip_relocation, catalina:       "ac57f5ffc3e1ac884d74b08dddce518e60f878e627cbfccc7dcb4642c5eb0653"
    sha256 cellar: :any_skip_relocation, mojave:         "444df3ab6a8ee34700f26459e93488d7ac3d3974ea29baa5d83f59d0014f6232"
    sha256 cellar: :any_skip_relocation, high_sierra:    "b41429cb8a4191a705b656b627a375cc32aaf8992cb241e30fe6c66c4ab56c9c"
    sha256 cellar: :any_skip_relocation, sierra:         "bc1358412281b1e486d9d1b6d25ae5665b02ac14f93f03603a966bd44ffda1d7"
    sha256 cellar: :any_skip_relocation, el_capitan:     "fbe092bfc501d4abf8b0df052e26307219ea4bb9fb4eddb20df8b7734ff7fdf5"
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
