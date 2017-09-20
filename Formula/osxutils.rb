class Osxutils < Formula
  desc "Collection of macOS command-line utilities"
  homepage "https://github.com/specious/osxutils"
  url "https://github.com/specious/osxutils/archive/v1.9.0.tar.gz"
  sha256 "9c11d989358ed5895d9af7644b9295a17128b37f41619453026f67e99cb7ecab"
  head "https://github.com/specious/osxutils.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "576127145840dc6ffa7af17adeef36f61de6a9bafcb17b80286109103729cf41" => :sierra
    sha256 "8a3039916a2cc607a98f5d4576b534e341f7823b7b16bdcfa66fca487379f366" => :el_capitan
    sha256 "86cee8409262fdda5d6634a86a29fe2d0fcee537baa8c9696de3a8abd27c2aa8" => :yosemite
    sha256 "91808d79c75537c563ee9a36b45e21703fcc4377d6c6ea7e7215f5ad9b0aa605" => :mavericks
  end

  def install
    system "make"
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    assert_match "osxutils", shell_output("#{bin}/osxutils")
  end
end
