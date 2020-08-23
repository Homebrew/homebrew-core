class Noti < Formula
  desc "Trigger notifications when a process completes"
  homepage "https://github.com/variadico/noti"
  url "https://github.com/variadico/noti/archive/3.4.0.tar.gz"
  sha256 "8fcf494084ea6eacac2e55dfcaf978452e1af0139205cd23fce71bfb20dd17fe"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "2c1a4a0b6f970c9cccabcb119b9ec8c43494eba00c14fb2fc851ac4063cb88dc" => :catalina
    sha256 "013130b6505c40b91c091663726343f92d401727d4b02e84c5268a2a64a22f62" => :mojave
    sha256 "ed27cb9b0e02a8cd9ef880a95036ffa2159880fff334786ee594fef3677f97d1" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-mod=vendor", "-o", "#{bin}/noti", "cmd/noti/main.go"
    man1.install "docs/man/noti.1"
    man5.install "docs/man/noti.yaml.5"
  end

  test do
    system "#{bin}/noti", "-t", "Noti", "-m", "'Noti recipe installation test has finished.'"
  end
end
