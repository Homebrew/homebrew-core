class Noti < Formula
  desc "Trigger notifications when a process completes"
  homepage "https://github.com/variadico/noti"
  url "https://github.com/variadico/noti/archive/v2.2.2.tar.gz"
  sha256 "67a04fcebb017f49769ea5fd9215031f8902f1a8db30a7e1fff9a001e2e33e4d"

  bottle do
    cellar :any_skip_relocation
    sha256 "8baff42259e8a84030728190b1336cb3ba2e386543c99ddb309e096f558326bb" => :el_capitan
    sha256 "fdd0be4fe61be9327edcb4d2a855cf4ddf1285e0d0dc1cce1a970af38491e412" => :yosemite
    sha256 "287cb9696086509cabe97ac7d8942b02a7a1278daede859cc167a0c8fe581690" => :mavericks
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
