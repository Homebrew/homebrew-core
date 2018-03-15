class Noti < Formula
  desc "Trigger notifications when a process completes"
  homepage "https://github.com/variadico/noti"
  url "https://github.com/variadico/noti/archive/3.0.0.tar.gz"
  sha256 "604ca1da56ba73fac7ca4236ae57c51c6c415f15649aa9be50a987254ba91301"

  bottle do
    cellar :any_skip_relocation
    sha256 "9cb142666aac31a531a1b2a19cc189ee60e434a473598091007aba1517130e26" => :high_sierra
    sha256 "179e8d8193c769e4cf33fdf88f1eca91cf47c3a7c9e8bfafa79592e2f67d2337" => :sierra
    sha256 "cb31ca14565ef6c018837fd629553476ace59554ac78c14085ae836e9a770e83" => :el_capitan
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
