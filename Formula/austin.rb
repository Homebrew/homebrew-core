class Austin < Formula
  desc "Python frame stack sampler for CPython"
  homepage "https://github.com/P403n1x87/austin"
  url "https://github.com/P403n1x87/austin/archive/v3.4.0.tar.gz"
  sha256 "bae96582ea0cf6364d742dadb82c1990f43e94fa806b016558cb2ec9e42b55a8"
  license "GPL-3.0-or-later"
  head "https://github.com/P403n1x87/austin.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5106617c81b1ea430924822c75dd551da3d9d1a902bee8b69acf2514208521c1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "949dbd53462cbc88321d28e20c30bed5abfd8616b629ed912c40ce6c1ff0a18c"
    sha256 cellar: :any_skip_relocation, monterey:       "735790b7e8a0b4ad4da0eff91e58778826797da6570fa1c696360870a94c39cd"
    sha256 cellar: :any_skip_relocation, big_sur:        "e1db4b59770e65a969f967f897eb17929d02607606c09fc076bf09a7bf7a3912"
    sha256 cellar: :any_skip_relocation, catalina:       "4bf6d1c0b1857ed9d621fc6ccd49349c81d842c33e30b55bfd99530e6aa80916"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "989600ad349c6fb01ba23186537b77c400b3a5db0933f743269ef879398436c9"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "python@3.10" => :test

  def install
    system "autoreconf", "--install"
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
    man1.install "src/austin.1"
  end

  test do
    python = Formula["python@3.10"].opt_bin/"python3.10"
    shell_output(bin/"austin #{python} -c \"from time import sleep; sleep(1)\"", 37)
  end
end
