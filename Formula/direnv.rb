class Direnv < Formula
  desc "Load/unload environment variables based on $PWD"
  homepage "https://direnv.net/"
  url "https://github.com/direnv/direnv/archive/v2.17.0.tar.gz"
  sha256 "1402cfbd9988cfe86d0ded47bd9732a061581f04bdb6275f156d8654e4d09a3a"
  head "https://github.com/direnv/direnv.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "78bff0d39fdcd0537d54341e7c493bb23fac13ec05527d3b74368d577a2c0cad" => :mojave
    sha256 "f54773e70dde4fb37c0b3a1b4b16ef28a3d7cfd5367c8dd89432117a13244b13" => :high_sierra
    sha256 "a3a267e89eeb368353f7fdc397c92feada57c4844aa6e881a3262518f3aa2f20" => :sierra
    sha256 "3597f6f4f7791f4482e540e189d845fa2cc9f0fc9d189ba467103dd5c91fd3e9" => :el_capitan
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
