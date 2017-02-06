class Gnuski < Formula
  desc "Open source clone of Skifree"
  homepage "http://gnuski.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/gnuski/gnuski/gnuski-0.3/gnuski-0.3.tar.gz"
  sha256 "1b629bd29dd6ad362b56055ccdb4c7ad462ff39d7a0deb915753c2096f5f959d"

  bottle do
    cellar :any_skip_relocation
    sha256 "8dbf391590db15b5fc88034e5b964d1f938044e0a99c317ffc523bda3586a6ec" => :el_capitan
    sha256 "11cc6933909b99946c338d372d8a967ef8cccd1e7f43b3ee727f149c193ebfc6" => :yosemite
    sha256 "82066055b0f45e86adb2ca749980a9d455d31bdf042ec8d0c9444e7a9a5e82a3" => :mavericks
  end

  def install
    system "make"
    bin.install "gnuski"
  end
end
