class Ponysay < Formula
  desc "Cowsay but with ponies"
  homepage "http://erkin.co/ponysay/"
  url "https://github.com/erkin/ponysay/archive/3.0.3.tar.gz"
  sha256 "c382d7f299fa63667d1a4469e1ffbf10b6813dcd29e861de6be55e56dc52b28a"

  bottle do
    cellar :any_skip_relocation
    sha256 "9e6e2bac2ed5e4619501bfd2c10e42847537a54fad0cd1e86d7a1d3ac7aa804d" => :high_sierra
    sha256 "4209ab259798a33086ee4af39fd260b1ed7f6ac3dc9a8b2b44cb9935129f17a5" => :sierra
    sha256 "69e2eb767ee25491e2a30893478bfdeff72023369ad4d9999f4b274e11b732f3" => :el_capitan
    sha256 "157fe5f14e1be281708d2c59987331484c40bd4d49d82c208bb7220503ba113a" => :yosemite
    sha256 "6c8ec0c8031407d5035f6cb7355deed95e6443c7200276ea5419ac31f2db4082" => :mavericks
    sha256 "45f26bc2439d8195651578ceee7f0b5cff318c2ba6b258b0533ce57ba6342ab0" => :mountain_lion
  end

  depends_on :python3
  depends_on "coreutils"

  def install
    system "./setup.py",
           "--freedom=partial",
           "--prefix=#{prefix}",
           "--cache-dir=#{prefix}/var/cache",
           "--sysconf-dir=#{prefix}/etc",
           "install"
  end

  test do
    system "#{bin}/ponysay", "-A"
  end
end
