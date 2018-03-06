class Onetime < Formula
  desc "Encryption with one-time pads"
  homepage "http://red-bean.com/onetime/"
  revision 1

  stable do
    url "http://red-bean.com/onetime/onetime-1.81.tar.gz"
    sha256 "36a83a83ac9f4018278bf48e868af00f3326b853229fae7e43b38d167e628348"

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
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "9f73f9cdb465fce1aefc3cf80c00bc8e43b41a33c3e999fb3ec531251cfc3da0" => :high_sierra
    sha256 "9f73f9cdb465fce1aefc3cf80c00bc8e43b41a33c3e999fb3ec531251cfc3da0" => :sierra
    sha256 "9f73f9cdb465fce1aefc3cf80c00bc8e43b41a33c3e999fb3ec531251cfc3da0" => :el_capitan
  end

  devel do
    url "http://red-bean.com/onetime/onetime-2.0-beta13.tar.gz"
    # FIXME: I can't rememeber why the custom version was added now, but
    # we're stuck with it now as 2.0-beta(n) is "less" than 2.0.0(n).
    version "2.0.13"
    sha256 "573c7f3a380a9c844dce7f8fe9dcc0086a7b0614b11a56f0b740617bc3dbfe52"
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
