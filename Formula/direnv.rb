class Direnv < Formula
  desc "Load/unload environment variables based on $PWD"
  homepage "https://direnv.net/"
  url "https://github.com/direnv/direnv/archive/v2.16.0.tar.gz"
  sha256 "a17eb4e3ba7600699541a0ac1d7e820b6faf1f2dcda02f791f6e69548d7bb0aa"
  head "https://github.com/direnv/direnv.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b4509e97d0d14117549bd3f644f0ec54c2085eb2c16e694ccf149c34d22b1889" => :high_sierra
    sha256 "8daab336341ef82968626d04f884455165da4a80863675caf86848aac2e2c691" => :sierra
    sha256 "88e6545130af2f187e3b4242c421a0bb79e1f304de8c111ceac57ad0cc004666" => :el_capitan
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
