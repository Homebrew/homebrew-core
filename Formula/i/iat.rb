class Iat < Formula
  desc "Converts many CD-ROM image formats to ISO9660"
  homepage "https://sourceforge.net/projects/iat.berlios/"
  url "https://downloads.sourceforge.net/project/iat.berlios/iat-0.1.7.tar.bz2"
  sha256 "fb72c42f4be18107ec1bff8448bd6fac2a3926a574d4950a4d5120f0012d62ca"
  license "GPL-2.0-or-later"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "4b7a2e6c46ce91c6a4eed38ff68cf506e7d37520266d57c222edb4ec5947b233"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "f6bc109730274136edd66490ce1029a7e48d083a418924684adbd72154a1ea84"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b9bf951c493709c86c80ded9cfda13a70c2fb7c6736ed66403bd493cd4267c5e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a0db42bcd57f51e6e6ae308b4e5999449bd70113b22e1e581331b892895d1c52"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "093c585bccdf3c2befc96c8050fc922267769a8d11e5d8d613aaaf5771ccc5cb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d62b3a234d80f15acfed8e030897b09f88678213024c5b5f47ae667507984d24"
    sha256 cellar: :any_skip_relocation, sonoma:         "bdb26eec9b7caef99572119093011954c596d32273d663bad57e98e869cdbc05"
    sha256 cellar: :any_skip_relocation, ventura:        "e01adc32b1913dab6e6907a82fcc5865c6f7d9cf1d18ea65225fb45726862fef"
    sha256 cellar: :any_skip_relocation, monterey:       "9cd2da0793bd90422e81e10cc2748b3d5c27cdb8fb2e47d167cc0bf2a94ed096"
    sha256 cellar: :any_skip_relocation, big_sur:        "a1a5029ab927dc08cf6cf89a583c52e475dd50521d461f5ed3d05056a7605dc1"
    sha256 cellar: :any_skip_relocation, catalina:       "6400e0c863f951cf324e9630ad9de91cc099e5d3f9cfd34f3cfa4344eb747cf3"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "eedb0ed17c84f3336f603a629de7b551aac5f37d77cb79236aa3caaff3901562"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5f6c91342941bb21b0ac060ac56c8453578655e499ef758ab2c7366ce2052d47"
  end

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}",
                          "--includedir=#{include}/iat"
    system "make", "install"
  end

  test do
    system bin/"iat", "--version"
  end
end
