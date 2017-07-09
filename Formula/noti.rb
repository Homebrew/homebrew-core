class Noti < Formula
  desc "Trigger notifications when a process completes"
  homepage "https://github.com/variadico/noti"
  url "https://github.com/variadico/noti/archive/v2.6.0.tar.gz"
  sha256 "642cecde4463c88d94f5d0ebedb6556176f841119389f2a79b87e4b08e4c69e8"

  bottle do
    cellar :any_skip_relocation
    sha256 "7d02a6c9a1490f374846e26c0f828dbd501e4d169c9838e895c71d637b88314c" => :sierra
    sha256 "3a0b4ac3ad6c4873a1b64f2f9abbba34732cef9d94540e574c7c52c859ea9a57" => :el_capitan
    sha256 "8d3101e0345632d72bbeb547f5d192022608db9e78bf9c461a14bb9559a18dc2" => :yosemite
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
