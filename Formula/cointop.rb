class Cointop < Formula
  desc "Interactive terminal based UI application for tracking cryptocurrencies"
  homepage "https://cointop.sh"
  url "https://github.com/miguelmota/cointop/archive/1.4.1.tar.gz"
  sha256 "d7dfb237c2de5acdccf717fbf4b141cd6c7ae9f643e12a5d2bc5c3efb0cfc3ce"

  bottle do
    cellar :any_skip_relocation
    sha256 "ec3315959d76a14ec024e118023ae93ccc978a2f708954f58f97a184e1f846a1" => :catalina
    sha256 "6ca7fb14bebc07fccdb7dbebdb8c0731440c46ac925009453b7998620f641cf2" => :mojave
    sha256 "26ce47cf63a324f26a77a04fd132e69b79de006f8ace83b8c583da4025933ed3" => :high_sierra
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
    system bin/"cointop", "test"
  end
end
