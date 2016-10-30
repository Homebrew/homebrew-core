class Noti < Formula
  desc "Trigger notifications when a process completes"
  homepage "https://github.com/variadico/noti"
  url "https://github.com/variadico/noti/archive/v2.4.0.tar.gz"
  sha256 "9bc4005823b438d4016281b2c2230a300cda881c8464c7a704e08cc745cabb8c"

  bottle do
    cellar :any_skip_relocation
    sha256 "b2235124fdb74efaf90e05d1ddb24e753a84f19e9487d1c5d2bad6c2f43b3e33" => :sierra
    sha256 "cbe77e9f1f35d5772b3de5aa5346e1e0e2dfa663b0fa6ad59a3b44c4c4346b2b" => :el_capitan
    sha256 "442e1e8e1dddc90855de682fa2a68f3236f94dc4934c6cc4c0a3336b0fc633b9" => :yosemite
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
