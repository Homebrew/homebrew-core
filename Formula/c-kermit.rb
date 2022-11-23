class CKermit < Formula
  desc "Scriptable network and serial communication for UNIX and VMS"
  homepage "https://www.kermitproject.org/"
  url "https://www.kermitproject.org/ftp/kermit/archives/cku302.tar.gz"
  version "9.0.302"
  sha256 "0d5f2cd12bdab9401b4c836854ebbf241675051875557783c332a6a40dac0711"
  license "BSD-3-Clause"

  # C-Kermit archive file names only contain the patch version and the full
  # version has to be obtained from text on the project page.
  livecheck do
    url "https://www.kermitproject.org/ckermit.html"
    regex(/The current C-Kermit release is v?(\d+(?:\.\d+)+) /i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "496449775776f60014f2ba1a7cfb15ae2ef68406be08a017c916e8b4007a9606"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "652b323375488103e967db89a319cc16cca1e10e89fcfa884aa53277e0a37193"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d955b3b42d7645769fddf390632af6f113969c349f72677cd1581a86f8b82892"
    sha256 cellar: :any_skip_relocation, ventura:        "9e51cc20d9b64bab69601ea103a0cac1a083ad0886d72412dfb18df5bcc82131"
    sha256 cellar: :any_skip_relocation, monterey:       "effa2227e450791dbca069fa6e22c2c98a24d46754d6f76e32a2f0f0149355df"
    sha256 cellar: :any_skip_relocation, big_sur:        "8f78db34bdbe18b861392eb2ef15aa8d1cf7f869f6bbcaadcb4633bef72965b6"
    sha256 cellar: :any_skip_relocation, catalina:       "fea40d461340389165bcaf8ce5fa074d703baef9a44252d25b3a0f96c29660cf"
    sha256 cellar: :any_skip_relocation, mojave:         "3021e5f091b9bd56f3b5b1f289552ba83b1d6c10b229fac9aaeb8bbbecdc6f6e"
    sha256 cellar: :any_skip_relocation, high_sierra:    "b6eae07c8d3365501f4e13af80b54ded073a2b1fc09fa885a445c7f52d96d589"
    sha256 cellar: :any_skip_relocation, sierra:         "b19ecd36ee298cba626b1276c228cdb4ee57726cf5af64166d8ff2800067e926"
    sha256 cellar: :any_skip_relocation, el_capitan:     "446776aff790c8f3b6f30be915dc18f4beffa973b92201384682beb7dc714562"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "982c8eb9c1956b669d4f769cb1c70a0cc7f32848674aba10e5aa906de57bdd1d"
  end

  uses_from_macos "ncurses"

  def install
    os = OS.mac? ? "macosx" : "linux"
    system "make", os
    man1.mkpath

    # The makefile adds /man to the end of manroot when running install
    # hence we pass share here, not man.  If we don't pass anything it
    # uses {prefix}/man
    system "make", "prefix=#{prefix}", "manroot=#{share}", "install"
  end

  test do
    assert_match "C-Kermit #{version}",
                 shell_output("#{bin}/kermit -C VERSION,exit")
  end
end
