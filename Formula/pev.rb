class Pev < Formula
  desc "PE analysis toolkit"
  homepage "https://pev.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/pev/pev-0.81/pev-0.81.tar.gz"
  sha256 "921b2831ca956aedc272d8580b2ff1a2cb54fb895cabeb81c907fe62b6ac83fb"
  license "GPL-2.0-or-later"
  head "https://github.com/merces/pev.git"

  livecheck do
    url :stable
  end

  bottle do
    sha256 "57ebf53a0c9647eca2f604ef68354c207f7baf3929affa40b5e1147771dd7245" => :big_sur
    sha256 "594049ef545f762b9f6d3cad098fa23971c0b84a3623799004c83e62a7303779" => :catalina
    sha256 "e4d191b795eebb97ee0bb6a3122bf45f1c2f05c7b192381e712d96d71cd4ffb0" => :mojave
    sha256 "70c993e146e9d78b9d8d129f06c4a67071f110d286d87fccf1132a7022833a1b" => :high_sierra
    sha256 "228fda2113236b984e337abf64064684c2e14c8e73eb62367ad1bc5cbe43215b" => :sierra
  end

  depends_on "openssl@1.1"
  depends_on "pcre"

  def install
    ENV.deparallelize
    system "make", "prefix=#{prefix}", "CC=#{ENV.cc}"
    system "make", "prefix=#{prefix}", "install"
  end

  test do
    system "#{bin}/pedis", "--version"
  end
end
