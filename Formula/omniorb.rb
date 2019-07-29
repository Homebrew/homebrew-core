class Omniorb < Formula
  desc "IOR and naming service utilities for omniORB"
  homepage "https://omniorb.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/omniorb/omniORB/omniORB-4.2.3/omniORB-4.2.3.tar.bz2"
  sha256 "26412ac08ab495ce5a6a8e40961fa20b7c43f623c6c26b616d210ca32f078bca"

  bottle do
    cellar :any
    sha256 "e83175a98726c50971b3be9058eff3625987ad318df5a3272c4c6a19df7b401e" => :mojave
    sha256 "603cee3162a0601304361565b3ee1e23b81770a8bc273f1bacbdbef7c06a19b1" => :high_sierra
    sha256 "5d005d42b413d7cb693321eab9e5ff7dc8e39b5c731da30c4adabf15138974cf" => :sierra
  end

  depends_on "pkg-config" => :build

  resource "bindings" do
    url "https://downloads.sourceforge.net/project/omniorb/omniORBpy/omniORBpy-4.2.3/omniORBpy-4.2.3.tar.bz2"
    sha256 "5c601888e57c7664324357a1be50f2739c468057b46fba29821a25069fc0aee5"
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"

    resource("bindings").stage do
      system "./configure", "--prefix=#{prefix}"
      system "make", "install"
    end
  end

  test do
    system "#{bin}/omniidl", "-h"
  end
end
