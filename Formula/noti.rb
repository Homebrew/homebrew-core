class Noti < Formula
  desc "Trigger notifications when a process completes"
  homepage "https://github.com/variadico/noti"
  url "https://github.com/variadico/noti/archive/v2.3.0.tar.gz"
  sha256 "2e1f2310743826f687a2fbd34654795da3c1a9e91ee34e3931f5321397122daa"

  bottle do
    cellar :any_skip_relocation
    sha256 "8df2d0230ae15425b49c14d3f84772114f7392e355ea2e0af7ed80564a8ebfc7" => :sierra
    sha256 "a1a6a536e0bed405afa38ed991a384022dc78145b0592207afc9b81d98f851e9" => :el_capitan
    sha256 "39e250fd963f55f25a6433226ac956e6d59dd070b4ac112f94e38b3937a877ec" => :yosemite
    sha256 "cae07c7c8a9e506974879cd37c1e146924bfdf527bb29ed51205f28fd33a22f9" => :mavericks
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
