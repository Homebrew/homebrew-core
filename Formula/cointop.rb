class Cointop < Formula
  desc "Interactive terminal based UI application for tracking cryptocurrencies"
  homepage "https://cointop.sh"
  url "https://github.com/miguelmota/cointop/archive/1.1.6.tar.gz"
  sha256 "a7f11576080fe04215785b81caec05e8a49e5ed2a8f529b1ce13b064e21e80c0"

  bottle do
    cellar :any_skip_relocation
    sha256 "21feaa71a82a78c005d76af760087d309b954a513e0ee2a7455585cbe1eb7e6a" => :mojave
    sha256 "ef142d85b9d2c6af4f9f463157cfda38df76d81b82ea8a0157bff3414c1c4b9d" => :high_sierra
    sha256 "fd3a7e27039906da70ac9f034090a20240248074ed7bc50a1961a76f81010df8" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    src = buildpath/"src/github.com/miguelmota/cointop"
    src.install buildpath.children
    src.cd do
      system "go", "build", "-o", bin/"cointop"
      prefix.install_metafiles
    end
  end

  test do
    system bin/"cointop", "-test"
  end
end
