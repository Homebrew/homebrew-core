class JpegArchive < Formula
  desc "Utilities for archiving JPEGs for long term storage"
  homepage "https://github.com/danielgtaylor/jpeg-archive"
  url "https://github.com/danielgtaylor/jpeg-archive/archive/refs/tags/v2.2.0.tar.gz"
  sha256 "3da16a5abbddd925dee0379aa51d9fe0cba33da0b5703be27c13a2dda3d7ed75"
  license "MIT"
  revision 1

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "405b8a9fadced6da12284f64413f6b196fc7be10ab17c6bf2343a892e3a3e319"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "01115c8c03cc35f2460ef29b711a0a2bb26c847d7363e352a720c2c6d71d62e6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "baf9261d5b80bc442cbf7ea1e7f4f98f8e52339009dfecad4175e8622f283382"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fab1849787fa6dc209963175b418748a9b92bdb64f0a39a4329afac2d8b262f0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cbaf592384b0d9906eb44217daa1971ec19d571cbc4cd25c2a14caa2451428e8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6608df468a7af8298e39f54afc7b391cd9660bdd88783850577d86862b6ccb51"
    sha256 cellar: :any_skip_relocation, sonoma:         "93023158605c8b8a20c8551a84b43755b5890371c720ec9173bd316fd71307df"
    sha256 cellar: :any_skip_relocation, ventura:        "0009726c390613fd0ed7f47a95383df4454efd2291da691129539f6ab32422f6"
    sha256 cellar: :any_skip_relocation, monterey:       "3461975fc932a94798f2d7c6cad3f030081a29a24a31bc391e2344c6aa6ed177"
    sha256 cellar: :any_skip_relocation, big_sur:        "41ac0d9c5bd290d77e7e5548a2257c6455f9f87265b06b5dc4e02ac7836dfc22"
    sha256 cellar: :any_skip_relocation, catalina:       "222d7258f63f000794693bc5912c88ce42d0a33473a8acbbc585821655c9b8dd"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "df29c9474117299a63359908e72c5693102a56fd57245a9d60f844427473a28b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "620b18311f4e6b970b2b9ae2c2cd6ee5625a791f158b3c2f219e617920d94796"
  end

  depends_on "mozjpeg"

  def install
    # Work around failure from GCC 10+ using default of `-fno-common`
    # multiple definition of `progname'; /tmp/ccMJX1Ay.o:(.bss+0x0): first defined here
    # multiple definition of `VERSION'; /tmp/ccMJX1Ay.o:(.bss+0x8): first defined here
    ENV.append_to_cflags "-fcommon" if OS.linux?

    system "make", "install", "PREFIX=#{prefix}", "MOZJPEG_PREFIX=#{Formula["mozjpeg"].opt_prefix}"
  end

  test do
    system bin/"jpeg-recompress", test_fixtures("test.jpg"), "output.jpg"
  end
end
