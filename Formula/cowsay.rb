class Cowsay < Formula
  desc "Configurable talking characters in ASCII art"
  # Historical homepage: https://web.archive.org/web/20120225123719/www.nog.net/~tony/warez/cowsay.shtml
  homepage "https://github.com/tnalpgge/rank-amateur-cowsay"
  url "https://github.com/tnalpgge/rank-amateur-cowsay/archive/cowsay-3.04.tar.gz"
  sha256 "d8b871332cfc1f0b6c16832ecca413ca0ac14d58626491a6733829e3d655878b"
  license "GPL-3.0"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8d35c9dfb46eea22b2b53c9c0deb00d7d95b6fe3fcfeb8d9404fd269d5739790"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8d35c9dfb46eea22b2b53c9c0deb00d7d95b6fe3fcfeb8d9404fd269d5739790"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dc3cb88861e89bb415d3b1be1b5314514174349bb44338551e80badc4da94542"
    sha256 cellar: :any_skip_relocation, ventura:        "23f11aa0196e2129ac8f293ac486dbc631de8a2f7786c1bb7c9d8642144f2856"
    sha256 cellar: :any_skip_relocation, monterey:       "23f11aa0196e2129ac8f293ac486dbc631de8a2f7786c1bb7c9d8642144f2856"
    sha256 cellar: :any_skip_relocation, big_sur:        "422c58f10fc2441a62a90864d01b83176ebda627f9a8c29b34f89f4f1f86618e"
    sha256 cellar: :any_skip_relocation, catalina:       "c1f4af994e038a18492c8afe0f6b97cfd1c475fe62eafe68762cf5d734dc214d"
    sha256 cellar: :any_skip_relocation, mojave:         "faebbfa7a9379fd4efddc43dc167fda055989d2936b0430e404c252a555439cc"
    sha256 cellar: :any_skip_relocation, high_sierra:    "4cdddb22ad76cf14527347e58317caf1495dc88fdf5d6c729ac72fa2fe19dd81"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8d35c9dfb46eea22b2b53c9c0deb00d7d95b6fe3fcfeb8d9404fd269d5739790"
  end

  def install
    # Remove offensive content
    %w[cows/sodomized.cow cows/telebears.cow].each do |file|
      rm file
      inreplace "Files.base", file, ""
    end

    system "/bin/sh", "install.sh", prefix
    mv prefix/"man", share
  end

  test do
    output = shell_output("#{bin}/cowsay moo")
    assert_match "moo", output  # bubble
    assert_match "^__^", output # cow
  end
end
