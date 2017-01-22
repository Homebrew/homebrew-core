class LeanCli < Formula
  desc "Command-line tool to develop and manage LeanCloud apps."
  homepage "https://github.com/leancloud/lean-cli"
  url "https://github.com/leancloud/lean-cli/archive/v0.6.0.tar.gz"
  sha256 "94d5e90ab9c9992ea0bc2491646141d86070f2f6cea251308b08315ebd6acc19"
  head "https://github.com/leancloud/lean-cli.git"

  bottle do
    sha256 "51f91a2c88a2e58a36898b2f831c76fecbb6a4f89a1271cedc07c48f85f5c809" => :sierra
    sha256 "4d4db3335b7005a390cd12b08d369db96abe36bec452b016b9b92578ce9d884d" => :el_capitan
    sha256 "b13bb432b12133509b8cf855d8ff851fb2c16516b790958d1b0f675d1500a68a" => :yosemite
  end

  depends_on "go" => :build

  def install
    build_from = build.head? ? "homebrew-head" : "homebrew"
    ENV["GOPATH"] = buildpath
    mkdir_p buildpath/"src/github.com/leancloud/"
    ln_s buildpath, buildpath/"src/github.com/leancloud/lean-cli"
    system "go", "build", "-o", bin/"lean",
                 "-ldflags", "-X main.pkgType=#{build_from}",
                 "github.com/leancloud/lean-cli/lean"
  end

  test do
    assert_match "lean version #{version}", shell_output("#{bin}/lean --version")
  end
end
