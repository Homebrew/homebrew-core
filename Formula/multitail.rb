class Multitail < Formula
  desc "Tail multiple files in one terminal simultaneously"
  homepage "https://vanheusden.com/multitail/"
  url "https://vanheusden.com/multitail/multitail-6.4.2.tgz"
  sha256 "af1d5458a78ad3b747c5eeb135b19bdca281ce414cefdc6ea0cff6d913caa1fd"
  head "https://github.com/flok99/multitail.git"

  bottle do
    rebuild 1
    sha256 "d61b7ec5070d9ce5d4430c2a4b91406b1f50fc4debb26064200aece8fbb86581" => :catalina
    sha256 "9d561e3132f6749aec218961f65d84516cc6a99a2247ee6ef4abf6ed1accc942" => :mojave
    sha256 "b8d2ab93cd8bf7954ffc49ed929aa0cf2c60a2ebeb872e9d3686d314af043be2" => :high_sierra
    sha256 "ec1007a1ab7ffc9394f25d1a838d54051c04c14667721e8db9f49803084f6dcc" => :sierra
    sha256 "b9c5e200dab1bf30ef4bd9bb257d5728c6779552aab97a1ddc65d02ad697cd8f" => :el_capitan
  end

  def install
    system "make", "-f", "makefile.macosx", "multitail", "DESTDIR=#{HOMEBREW_PREFIX}"

    bin.install "multitail"
    man1.install gzip("multitail.1")
    etc.install "multitail.conf"
  end

  test do
    if build.head?
      assert_match "multitail", shell_output("#{bin}/multitail -h 2>&1", 1)
    else
      assert_match version.to_s, shell_output("#{bin}/multitail -h 2>&1", 1)
    end
  end
end
