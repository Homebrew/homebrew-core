class Fswatch < Formula
  desc "Monitor a directory for changes and run a shell command"
  homepage "https://github.com/emcrisostomo/fswatch"
  url "https://github.com/emcrisostomo/fswatch/releases/download/1.9.1/fswatch-1.9.1.tar.gz"
  sha256 "56d7e2ae092985839f9f26b56cfbb5b08f9741d008a5aca75ddc7563e3b75fc8"

  bottle do
    cellar :any
    sha256 "3a540a746c4365f8612b900947bcd9b03bf9983b68c7338a0330b3e3071fc287" => :el_capitan
    sha256 "0ba0ba279855ff12376a1bf91e0825bcec109edf151336d161ce1abe329d32e7" => :yosemite
    sha256 "d8158b1e049e67a2f23ec31e2f509405fb6585b4da669d448c41dc9c7c06fb9d" => :mavericks
  end

  needs :cxx11

  def install
    ENV.cxx11
    system "./configure", "--prefix=#{prefix}",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules"
    system "make", "install"
  end
end
