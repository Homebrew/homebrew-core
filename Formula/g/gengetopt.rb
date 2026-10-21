class Gengetopt < Formula
  desc "Generate C code to parse command-line arguments via getopt_long"
  homepage "https://www.gnu.org/software/gengetopt/"
  url "https://ftpmirror.gnu.org/gengetopt/gengetopt-2.23.1.tar.xz"
  mirror "https://ftp.gnu.org/gnu/gengetopt/gengetopt-2.23.1.tar.xz"
  sha256 "3b9def48422bd45f78af95936200b7f9287369a3db76c4907c42fe10f4922ab6"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "9587eb09436394fc491df82712e888c498bc1b7edeeb4c4706089fb9f2394263"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d068762823bfed802d5712f0823b81c301ca75b754e3277686af530d02fe56b7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "10fa72931c244ef845288d2ecd5281ed895bfb0548c645caee6580ffcccccc1d"
    sha256 cellar: :any,                 arm64_linux:       "2f00f486ebf2493457a779c01c86aae6bd496e97037fcd40d7be906eca59cb8f"
    sha256 cellar: :any,                 x86_64_linux:      "6db5a0e8db4fe04bbcc9cd2811fe46d8846142068213f5240e17a871f941f3d6"
  end

  on_system :linux, macos: :ventura_or_newer do
    depends_on "texinfo" => :build
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"

    ENV.deparallelize
    system "make", "install"
  end

  test do
    ggo = <<~EOS
      package "homebrew"
      version "0.9.5"
      purpose "The missing package manager for macOS"

      option "verbose" v "be verbose"
    EOS

    pipe_output("#{bin}/gengetopt --file-name=test", ggo, 0)
    assert_path_exists testpath/"test.h"
    assert_path_exists testpath/"test.c"
    assert_match(/verbose_given/, File.read("test.h"))
  end
end
