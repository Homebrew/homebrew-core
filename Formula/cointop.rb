class Cointop < Formula
  desc "Interactive terminal based UI application for tracking cryptocurrencies"
  homepage "https://cointop.sh"
  url "https://github.com/miguelmota/cointop/archive/1.1.2.tar.gz"
  sha256 "69070f6b610f31f64245052910b4bd940a3e722f7326e7959c95f47ebe1c38ba"

  bottle do
    cellar :any_skip_relocation
    sha256 "221ff054d2034edf7a53fe0a17cd49c884bd094fceabdf66d9bd1704cfc62ca1" => :mojave
    sha256 "d85db44fb5a9691991d0a413368cda6e99911bb92ab80437933c98673c2f82f4" => :high_sierra
    sha256 "0f0b9038f212eeb29b14693f05cc5cbdb48ae40f26f159d92d0744fdbc1fc27b" => :sierra
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
    system bin/"cointop", "-test"
  end
end
