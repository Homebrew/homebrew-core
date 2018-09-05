class Dmalloc < Formula
  desc "Debug versions of system memory management routines"
  homepage "http://dmalloc.com"
  url "http://dmalloc.com/releases/dmalloc-5.5.2.tgz"
  sha256 "d3be5c6eec24950cb3bd67dbfbcdf036f1278fae5fd78655ef8cdf9e911e428a"

  bottle do
    cellar :any_skip_relocation
    sha256 "f4bd200bf3b14f68387a1110588f10cbd813b5fddcb585d0edf48d48ece5a8ee" => :mojave
    sha256 "ad501bd5d70dfd3ede2258c0a7c0535b29eba957b67271e4db930ecf6bcc845f" => :high_sierra
    sha256 "9807e6014702bc1350fe0931dbd9bdabcca169b6c8f196ddf37c9f0abfa1b722" => :sierra
    sha256 "9e1b5dad96d27fbd31e249de7965963fa2e8028286a5e41ce7ddf4555b344162" => :el_capitan
    sha256 "9283914d34d43556b6a3779523834a056c78d565efacf4316846b1af90cedaf5" => :yosemite
    sha256 "182c639d938b8b4fb237f7068bc295debba2539bf500adbb8761dabd99b3fcbf" => :mavericks
  end

  def install
    system "./configure", "--enable-threads", "--prefix=#{prefix}"
    system "make", "install", "installth", "installcxx", "installthcxx"
  end

  test do
    system "#{bin}/dmalloc", "-b", "runtime"
  end
end
