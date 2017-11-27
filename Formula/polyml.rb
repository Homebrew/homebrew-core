class Polyml < Formula
  desc "Standard ML implementation"
  homepage "http://www.polyml.org"
  url "https://github.com/polyml/polyml/archive/v5.7.1.tar.gz"
  sha256 "d18dd824b426edaed1cec71dded354b57df9ebdbd38863bc7540a60bd0667028"
  head "https://github.com/polyml/polyml.git"

  bottle do
    sha256 "e533dc791e3583ad45f55c15a3895664569a02f90675326cae5008fddd731f73" => :high_sierra
    sha256 "59ee15e0f1281b4b95dfa0a7e37ba1d88f05d29811312ec4f3fd67d47289868d" => :sierra
    sha256 "9e5d445fd251ff33ade65fa821aa7275ff1fb54b37295c4da9b3f93400ab58cc" => :el_capitan
    sha256 "d3a5221871918026176725fe056fac0d99668667e640f6b9418be4d8a3d18667" => :yosemite
  end

  def install
    system "./configure", "--disable-dependency-tracking", "--disable-debug",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end
end
