class Onetime < Formula
  desc "Encryption with one-time pads"
  homepage "http://red-bean.com/onetime/"

  stable do
    url "http://red-bean.com/onetime/onetime-1.81.tar.gz"
    sha256 "36a83a83ac9f4018278bf48e868af00f3326b853229fae7e43b38d167e628348"

    # Fixes the Makefile to permit destination specification
    # https://github.com/kfogel/OneTime/pull/12
    patch do
      url "https://github.com/kfogel/OneTime/commit/61e534e2.patch"
      sha256 "2c22ca15dd61448d71515ce7e03b7e05d38450fd59b673323c47ade7023cb64c"
    end

    # Follow up to PR12 to fix my clumsiness in a variable call.
    patch do
      url "https://github.com/kfogel/OneTime/commit/fb0a12f2.patch"
      sha256 "68be20314f513d126287e7d799dc6c57fb0ece4d28b85588c102a5144422bc80"
    end
  end

  bottle do
    cellar :any_skip_relocation
    rebuild 2
    sha256 "37cf417291ce11a6313bde209490f3cce0ca5f47b17579e28720568088de89fa" => :sierra
    sha256 "4d27502d9a4b8d257182dcaf99b05121033352928c3716a1ebe932a24276e73a" => :el_capitan
    sha256 "561f129baa60ba8aa08f47130a35f531fdd7ddda80c3e0636bd39c96c3d06930" => :yosemite
    sha256 "31698cc41c95bdb23f340f2641124826f8b5324a69ce338146e7c01800646fa5" => :mavericks
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
