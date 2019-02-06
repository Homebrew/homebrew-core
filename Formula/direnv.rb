class Direnv < Formula
  desc "Load/unload environment variables based on $PWD"
  homepage "https://direnv.net/"
  url "https://github.com/direnv/direnv/archive/v2.19.1.tar.gz"
  sha256 "0963dae84eed89cf0aaa1679830d0546d51c4952608912137c67e51c852a4011"
  head "https://github.com/direnv/direnv.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "79aa90ee07d79425bf1fe78cb2c93d4fc6f654c66b1ac622382f984c7fb7de32" => :mojave
    sha256 "faafe45371e2ee1cd9894b8b96ce185628eab723b50a3b85c3c0d0680f2bcb97" => :high_sierra
    sha256 "5041f10a620727561309140cb871963911f44d4ef7cb2540e6ee5c97ffcd67da" => :sierra
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
