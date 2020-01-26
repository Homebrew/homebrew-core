class Direnv < Formula
  desc "Load/unload environment variables based on $PWD"
  homepage "https://direnv.net/"
  url "https://github.com/direnv/direnv/archive/v2.21.1.tar.gz"
  sha256 "806480768d4f6598fb33a7d8a3a1b6ae11b858be53eecabd1ea3d31eee12b0a6"
  head "https://github.com/direnv/direnv.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "23b565746921f7371354763f338768c9afba741b548d48c62ee33e928f12cf41" => :catalina
    sha256 "82034e4be51b47e056f3fbe1d5b5983c05ab0158dd542b76eee1b56fbf3359ba" => :mojave
    sha256 "053eff7e7158c2fa145dd4fbd87a7e36eba357871ebb03f831a57474ff0e0f8e" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/direnv/direnv").install buildpath.children
    cd "src/github.com/direnv/direnv" do
      system "make", "install", "DESTDIR=#{prefix}"
      prefix.install_metafiles
    end
  end

  test do
    system bin/"direnv", "status"
  end
end
