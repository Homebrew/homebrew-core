class Austin < Formula
  desc "Python frame stack sampler for CPython"
  homepage "https://github.com/P403n1x87/austin"
  url "https://github.com/P403n1x87/austin/archive/v3.1.0.tar.gz"
  sha256 "1d1776350a2a083cbacbd6100e815cb5e4184bcc35517290c8f82e4e78f4ed7f"
  license "GPL-3.0-or-later"
  head "https://github.com/P403n1x87/austin.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "7f3464bfa7fd1f576832f25a56e19f551bf5c6778d77a158ca1b25b48f7c671d"
    sha256 cellar: :any_skip_relocation, big_sur:       "088ef140bf30d7b91cbfa194dabbacae049979a65a71fad25a6d550296af3589"
    sha256 cellar: :any_skip_relocation, catalina:      "a7ffc95aa5460830509c80307b327a10b170f22e7e35012c4cf4d3c5d1afb2d8"
    sha256 cellar: :any_skip_relocation, mojave:        "9fe770bb131628dab6120be4996b919a5b6eab70c45fb03e2e88f454dac8f6f0"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "python@3.9" => :test

  def install
    system "autoreconf", "--install"
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
    man1.install "src/austin.1"
  end

  test do
    shell_output("#{bin}/austin #{Formula["python@3.9"].opt_bin}/python3 -c \"from time import sleep; sleep(1)\"", 37)
  end
end
