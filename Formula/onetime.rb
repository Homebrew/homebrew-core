class Onetime < Formula
  desc "Encryption with one-time pads"
  homepage "https://www.red-bean.com/onetime/"
  url "https://www.red-bean.com/onetime/onetime-1.81.tar.gz"
  sha256 "36a83a83ac9f4018278bf48e868af00f3326b853229fae7e43b38d167e628348"
  license "MIT"
  revision 1

  livecheck do
    url "https://www.red-bean.com/onetime/get"
    regex(/href=.*?onetime[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d6b4a7ac553f33266044258c1b8cc8e703428990ec7c329ec1abcec649c94eaf"
    sha256 cellar: :any_skip_relocation, big_sur:       "3537657d8ff718b94fa84714b0105b95ef613fe778d04ff573a19df687798747"
    sha256 cellar: :any_skip_relocation, catalina:      "b55bb2391f7518b4139e2e57f851d0805329191be23630a6cf4d2a154a0e416c"
    sha256 cellar: :any_skip_relocation, mojave:        "0394155a2171bb959017a677a428403c0220c8f1cf39af2af72ce95f921396ed"
    sha256 cellar: :any_skip_relocation, high_sierra:   "9f73f9cdb465fce1aefc3cf80c00bc8e43b41a33c3e999fb3ec531251cfc3da0"
    sha256 cellar: :any_skip_relocation, sierra:        "9f73f9cdb465fce1aefc3cf80c00bc8e43b41a33c3e999fb3ec531251cfc3da0"
    sha256 cellar: :any_skip_relocation, el_capitan:    "9f73f9cdb465fce1aefc3cf80c00bc8e43b41a33c3e999fb3ec531251cfc3da0"
    sha256 cellar: :any_skip_relocation, all:           "93ec90f57aaf9235f925eb7146e3446a2265b5e6d573188bc129178aa516b1ad"
  end

  # Fixes the Makefile to permit destination specification
  # https://github.com/kfogel/OneTime/pull/12
  patch do
    url "https://github.com/kfogel/OneTime/commit/61e534e2.patch?full_index=1"
    sha256 "b74d1769e8719f06755c7c3c4ac759063b31d9d0554b64c5fb600c7edf5cc5ea"
  end

  # Follow up to PR12 to fix my clumsiness in a variable call.
  patch do
    url "https://github.com/kfogel/OneTime/commit/fb0a12f2.patch?full_index=1"
    sha256 "11417d66886630f7a3c527f63227a75a39aee18029e60de99d7cb68ebe7769f5"
  end

  def install
    system "make", "prefix=#{prefix}", "install"
    inreplace bin/"onetime", %r{^#!/usr/bin/env python$}, "#!/usr/bin/python"
  end

  test do
    system "dd", "if=/dev/random", "of=pad_data.txt", "bs=1024", "count=1"
    (testpath/"input.txt").write "INPUT"
    system bin/"onetime", "-e", "--pad=pad_data.txt", "--no-trace",
                          "--config=.", "input.txt"
    system bin/"onetime", "-d", "--pad=pad_data.txt", "--no-trace",
                          "--config=.", "input.txt.onetime"
  end
end
