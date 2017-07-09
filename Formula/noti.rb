class Noti < Formula
  desc "Trigger notifications when a process completes"
  homepage "https://github.com/variadico/noti"
  url "https://github.com/variadico/noti/archive/v2.6.0.tar.gz"
  sha256 "642cecde4463c88d94f5d0ebedb6556176f841119389f2a79b87e4b08e4c69e8"

  bottle do
    cellar :any_skip_relocation
    sha256 "cc2373da2a7b8d642b55f3f89aa8869f325246adc6a1ed01a1beb144ccdf0724" => :sierra
    sha256 "bb89dabb74f69180ea558fa2a67aff29e047df4f803816f45cc9d08879b3b4d3" => :el_capitan
    sha256 "a43cdd2046a358c0934a44e8d8c234daa8b24b61a09f6f8d931fea1b34ade156" => :yosemite
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath

    notipath = buildpath/"src/github.com/variadico/noti"
    notipath.install Dir["*"]

    cd "src/github.com/variadico/noti/cmd/noti" do
      system "go", "build"
      bin.install "noti"
      prefix.install_metafiles
    end
  end

  test do
    system "#{bin}/noti", "-t", "Noti", "-m", "'Noti recipe installation test has finished.'"
  end
end
