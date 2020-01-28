class Direnv < Formula
  desc "Load/unload environment variables based on $PWD"
  homepage "https://direnv.net/"
  url "https://github.com/direnv/direnv/archive/v2.21.2.tar.gz"
  sha256 "ce5551b09f71fe26111bbf94a09cfdbce14794ec9a723015b67efea804986d68"
  head "https://github.com/direnv/direnv.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "c1a78791c289f83b49f2f1d7eec8f350e25dfc24b7855609bffb2b4671d049c1" => :catalina
    sha256 "a6b2fecc32381b13a1cd44afad1724cece0dc6fee4caa4abdba6f0c99adf6ecc" => :mojave
    sha256 "b3d3d2d4fedf8c7bb10cf94dee5f8a0d77aa8ce768d8f8e2e0d63b99faf395d2" => :high_sierra
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
