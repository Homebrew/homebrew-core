class Pulledpork < Formula
  desc "Snort rule management"
  homepage "https://github.com/shirkdog/pulledpork"
  url "https://pulledpork.googlecode.com/files/pulledpork-0.7.0.tar.gz"
  sha256 "f60c005043850bb65a72582b9d6d68a7e7d51107f30f2b3fc67e607c995aa1a8"
  head "https://github.com/shirkdog/pulledpork.git"

  bottle :unneeded

  depends_on "Switch" => :perl
  depends_on "Crypt::SSLeay" => :perl

  def install
    bin.install "pulledpork.pl"
    doc.install Dir["doc/*"]
    etc.install Dir["etc/*"]
  end
end
