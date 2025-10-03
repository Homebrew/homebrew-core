class GnuGo < Formula
  desc "Plays the game of Go"
  homepage "https://www.gnu.org/software/gnugo/gnugo.html"
  url "https://ftpmirror.gnu.org/gnu/gnugo/gnugo-3.8.tar.gz"
  mirror "https://ftp.gnu.org/gnu/gnugo/gnugo-3.8.tar.gz"
  sha256 "da68d7a65f44dcf6ce6e4e630b6f6dd9897249d34425920bfdd4e07ff1866a72"
  # The `:cannot_represent` is for src/gtp.* which is similar to ICU license if
  # SPDX allowed replacing `this software ... (the "Software")` with `file gtp.c`
  license all_of: ["GPL-3.0-or-later", :public_domain, :cannot_represent]
  revision 1
  head "https://git.savannah.gnu.org/git/gnugo.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "65707404eb0034b25296dc8c9dfc0dd3ec1016b4ef97744500b702317c50b89c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "b638af6216ed0bd736823bab2fe42ca902dd9768a69fee4009726808aeeea448"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c4a8369ddd4c22df9f43cbc88b769da13639aacdde5876bf22f4e20f54789143"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "29d51049554c942b464d900b5bd264c2606af4775cec9c4c76cf1c170beefe91"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ed049166ae53dc93586ab3ac5b3a3b40209dc46c9acaec335683a6c6b2c104ea"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "93fd32bdebd46174fe9d1ff0572dea0859c0a9f29dad7d9e20097da446cea7ab"
    sha256 cellar: :any_skip_relocation, sonoma:         "48d3216a86c7421d136801315c761c7a4e442cf353186b529e491677bf79cdfa"
    sha256 cellar: :any_skip_relocation, ventura:        "aa6a55c92da6fc437dfc599fc84ec2a1f0e53d069efbfcb335d6a78da06d9177"
    sha256 cellar: :any_skip_relocation, monterey:       "b9394ee3acacef9bcb2c8df6a9fdd7547c99af2c0fd81f1dc1faa9e1b35c94df"
    sha256 cellar: :any_skip_relocation, big_sur:        "41b40531006a8e8c83d81b0c7628b7bd25a946e9d322e0ac8d5b5a91c999c0d4"
    sha256 cellar: :any_skip_relocation, catalina:       "b756b9307e6ff0a0cb9c05eca13ae12b3a9f6ee44219fa4a899e5301fffa2483"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "66bcee409ac058dc82af44e5ef563cee1dedaab9f2d1e0b2e527a8b5aacc8336"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "99e7447f557b3af1f8c1e56d9a30cbe4315bd9f05ec734fb2fadac5887ab0474"
  end

  def install
    # Work around failure from GCC 10+ using default of `-fno-common`
    # multiple definition of `DRAW'; globals.o:(.bss+0x0): first defined here
    ENV.append_to_cflags "-fcommon" if OS.linux?

    system "./configure", "--with-readline", *std_configure_args
    system "make", "install"
  end

  test do
    assert_match(/GNU Go #{version}$/, shell_output("#{bin}/gnugo --version"))
  end
end
