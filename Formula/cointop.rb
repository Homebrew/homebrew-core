class Cointop < Formula
  desc "Interactive terminal based UI application for tracking cryptocurrencies"
  homepage "https://cointop.sh"
  url "https://github.com/miguelmota/cointop/archive/1.1.2.tar.gz"
  sha256 "69070f6b610f31f64245052910b4bd940a3e722f7326e7959c95f47ebe1c38ba"

  bottle do
    cellar :any_skip_relocation
    sha256 "e0c4f46d2bc2910a7fd5866a57738106e07eadfae20aebd59661e03385829ab8" => :mojave
    sha256 "a88422c7be92ecaf8a0683f9c15a0c335503cab244962372f59d66fa71864cbb" => :high_sierra
    sha256 "61afdc62170ab00c9c12133e3e90d0f1168b6792cef7e26d23337f86aec8bd74" => :sierra
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
