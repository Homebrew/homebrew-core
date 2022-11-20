class Mscgen < Formula
  desc "Parses Message Sequence Chart descriptions and produces images"
  homepage "https://www.mcternan.me.uk/mscgen/"
  url "https://www.mcternan.me.uk/mscgen/software/mscgen-src-0.20.tar.gz"
  sha256 "3c3481ae0599e1c2d30b7ed54ab45249127533ab2f20e768a0ae58d8551ddc23"
  license "GPL-2.0-or-later"
  revision 4

  livecheck do
    url :homepage
    regex(/href=.*?mscgen-src[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "73676ae3da025d8b7aaabc9809c3f65c3b6ae85a8d69850d7bd30bd5af0007ce"
    sha256 cellar: :any,                 arm64_monterey: "3cd61f8ca37330ef4a7ba26132a5d3bdb3eea68f4f41307064dadc3dc5649fa5"
    sha256 cellar: :any,                 arm64_big_sur:  "cede56d6cd047fde4bb154591914ee1123d118080114fb82a5b156b895f8fad4"
    sha256 cellar: :any,                 ventura:        "b500d3fa67b119c59ff1a781dfe0909b12d0e3c9581ec1cf9cfcf39940a4c4f9"
    sha256 cellar: :any,                 monterey:       "d031bdc4d5456838a3b0c8d60108309e3b2878067fda80b747cd2c6de90cccb1"
    sha256 cellar: :any,                 big_sur:        "a62050a8f5e00af5a06fde06f2d87acc030dba511a1b6b97f49ea148423c6776"
    sha256 cellar: :any,                 catalina:       "aaa059273a50cf91bca121c093ce2adfd8bee71d854c6212df2d63b4bf7811e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5957b2f4840517592807494271eb28d63b5c245ac014d34be596fb0355129031"
  end

  depends_on "pkg-config" => :build
  depends_on "freetype"
  depends_on "gd"

  def install
    system "./configure", *std_configure_args, "--with-freetype"
    system "make", "install"
  end
end
