class Direnv < Formula
  desc "Load/unload environment variables based on $PWD"
  homepage "https://direnv.net/"
  url "https://github.com/direnv/direnv/archive/v2.15.1.tar.gz"
  sha256 "249dec1c9bc86a4d2382670a0c9a17e59197171ac889c3427bfb2d5929438978"
  head "https://github.com/direnv/direnv.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "c1ba63af502ec2f42ecacf9b927920d9697d47f7828b7b61da4d037f7f8243a7" => :high_sierra
    sha256 "8332498c8f1cc305f7841974e5378e7fd3bf4951778d65f952c72eb63141763f" => :sierra
    sha256 "47a1bcc399e34358383947bc042de6fb0424ce18514bc2fe6c7e6eb1ee885182" => :el_capitan
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
