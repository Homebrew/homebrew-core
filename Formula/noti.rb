class Noti < Formula
  desc "Trigger notifications when a process completes"
  homepage "https://github.com/variadico/noti"
  url "https://github.com/variadico/noti/archive/3.0.0.tar.gz"
  sha256 "604ca1da56ba73fac7ca4236ae57c51c6c415f15649aa9be50a987254ba91301"

  bottle do
    cellar :any_skip_relocation
    sha256 "5a63f09b546e77296a027a7624263854d2e14f7567c14e80ba00039c7e103049" => :high_sierra
    sha256 "ca4dffa990853c8a15e3575f378b72fc4ecfc76227762f060d5a52819f9a12f6" => :sierra
    sha256 "5cb76f8a66ce64787ec736ae07dd0a739a41f9c2a5dc69fc29e63a1352231548" => :el_capitan
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
