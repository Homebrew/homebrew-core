class Gti < Formula
  desc "ASCII-art displaying typo-corrector for commands"
  homepage "https://r-wos.org/hacks/gti"
  url "https://github.com/rwos/gti/archive/v1.7.0.tar.gz"
  sha256 "cea8baf25ac5e6272f9031bd5e36a17a4b55038830b108f4f24e7f55690198f7"
  head "https://github.com/rwos/gti.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "dc2f7bf9b442294a044b782321689783cd3fd93a465a9604db606b2b420e4443" => :catalina
    sha256 "2e1f996a67020a9bd842b41d0ac7d6e5ef0791fbc7fd57ffe3e9b7aacc1ee6de" => :mojave
    sha256 "9d46e56c0f79ba9d81e40bc1edc7b4ff1a9c9eeb4dbcb087827dec5b84c4f82b" => :high_sierra
  end

  def install
    system "make", "CC=#{ENV.cc}", "CFLAGS=#{ENV.cflags}"
    bin.install "gti"
    man6.install "gti.6"
  end

  test do
    system "#{bin}/gti", "init"
  end
end
