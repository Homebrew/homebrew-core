class Msktutil < Formula
  desc "Active Directory keytab management"
  homepage "https://sourceforge.net/projects/msktutil/"
  url "https://downloads.sourceforge.net/project/msktutil/msktutil-1.1.tar.bz2"
  sha256 "56bf4af8f74d8be6a8d94b90a527acf1508cd58212886fcfe54daa9799dcaf6f"
  license "GPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4b71c42ed1031ee7b78cc32565e0a3bf5abee42034a055e92e28628679b4fef4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f359bdca4a4282cddd3181d9c3f231c4d95dd99c7fd19e8118f9a1b460d80ad5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b30da17f59ba235a55d146e7af8e5c704105a4947f6cc8136764db2664ca67c1"
    sha256 cellar: :any_skip_relocation, ventura:        "22e28f1d16f83ecf7fc7eab5efa8b8439b356eb81c0f9c39e7ad09fe5ef6162f"
    sha256 cellar: :any_skip_relocation, monterey:       "175635f2d96e975165e31ee4701edf837b71a2c37c3884d50cf3216e97690423"
    sha256 cellar: :any_skip_relocation, big_sur:        "7792cda91c0fe3c5bb4858d5af90cc897fa193c0609a44be276da8397bc97549"
    sha256 cellar: :any_skip_relocation, catalina:       "aa3eeff895b2de1989222a0da68b9bfd1f82a84e1aa09e060f96a018c51c9f1d"
    sha256 cellar: :any_skip_relocation, mojave:         "c81aaec915e611272f5c74d5a4ee7b14d9e7342d7bc2639f45dd90b0f3fc639b"
    sha256 cellar: :any_skip_relocation, high_sierra:    "8f3695f42884ee17bc1b701ee968c60e5ff115c17b9514986c7dd499b8e229c2"
    sha256 cellar: :any_skip_relocation, sierra:         "05fc6f711b6109052fa1a795bf88063490e5c2ed73bcf2f2168610c77e996d88"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7b0b351e66db0c0f3aa14df7568d854e76cbf8d9dd4bc256f780cbe856af0d3e"
  end

  uses_from_macos "cyrus-sasl"
  uses_from_macos "krb5"
  uses_from_macos "openldap"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{sbin}/msktutil --version")
  end
end
