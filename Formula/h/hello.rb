class Hello < Formula
  desc "Program providing model for GNU coding standards and practices"
  homepage "https://www.gnu.org/software/hello/"
  url "https://ftp.gnu.org/gnu/hello/hello-2.12.1.tar.gz"
  sha256 "8d99142afd92576f30b0cd7cb42a8dc6809998bc5d607d88761f512e26c7db20"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "d933581c28ace3bc418f910aeb86aacc4465f727127b50e00b95dba985606009"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c1770a992b197e450da7cf2282fdeaae855765f66609063bfb963ffb2ccf69a5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cb3569886bfa1c197ea1db0b0eee32f5eff574454517ca64520c34adeff90404"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a0103553329c8a010ed68a1143bf9126b0f1977fec308953e9068a9722790d9d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e8c7459b0310a5c99d441e1a5814f9eb1723b11e84b58efad01c0db4aeaf8d36"
    sha256 cellar: :any_skip_relocation, sequoia:        "e256e8f273e3dac56c4806757e7fb4e6bfedf17e483e03bebe6627772ae3c7b7"
    sha256 cellar: :any_skip_relocation, sonoma:         "fba57a7f384eeab7d36b575b80054ddf2169249962139fc0c818553c1a1bdc6e"
    sha256 cellar: :any_skip_relocation, ventura:        "b430480afc7bb4107bc1a42930bf69baa7f1da42c2080cdf837e57f7a509147a"
    sha256 cellar: :any_skip_relocation, monterey:       "62534bceb8f7074827fa2146dd13603018aaf07c82e22cfef96571c8133ce8a1"
    sha256 cellar: :any_skip_relocation, big_sur:        "480a77f0f4e0ea6aa4175b3853feba7bdeda9f0b3dd808ad02eeb358b8a48f4a"
    sha256 cellar: :any_skip_relocation, catalina:       "c30c2be3191bd643f36e96b45b1282b5a750219bc8cab2e31d3c23d4cad5d70c"
    sha256                               x86_64_linux:   "7935d0efdae69742f5140d514ef2e3e50d1d7cb82104cf6033ad51b900c12749"
  end

  conflicts_with "perkeep", because: "both install `hello` binaries"

  def install
    ENV.append "LDFLAGS", "-liconv" if OS.mac?

    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
  test do
    assert_equal "brew", shell_output("#{bin}/hello --greeting=brew").chomp
  end
end
