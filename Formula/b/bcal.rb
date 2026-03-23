class Bcal < Formula
  desc "Storage conversion and expression calculator"
  homepage "https://github.com/jarun/bcal"
  url "https://github.com/jarun/bcal/archive/refs/tags/v2.5.tar.gz"
  sha256 "7e00d38aca2272ef93f55515841e2912ecf845914ec140f8e4c356e1493cf5cf"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d3282e866c6ab81d95728ba8e2f863a97bdf389417b194741c0b63f81eb65d03"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fcd6cc5fb598a558848647702c22444d8a40944b3eaf6ee92f02c2496fbc6b40"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b71b24116d10a0a414a1dc11687363d06b685549abea992d5be85e102bb05dcd"
    sha256 cellar: :any_skip_relocation, sonoma:        "27dd59b087eadb1eaea3287f49f37c12489d18a41a0f7ec2160cda03035b1805"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b68b2889f1b14c7c4978f1836d7854a572ac94888f9f3f9932ecd67919fa31b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "375590abb9324e0a68d3b0efb786624d10006fa3c8f766f4d9a2ed1745d92095"
  end

  on_linux do
    depends_on "readline"
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    assert_match "9333353817", shell_output("#{bin}/bcal '56 gb / 6 + 4kib * 5 + 4 B'")
  end
end
