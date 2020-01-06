class Cointop < Formula
  desc "Interactive terminal based UI application for tracking cryptocurrencies"
  homepage "https://cointop.sh"
  url "https://github.com/miguelmota/cointop/archive/1.4.4.tar.gz"
  sha256 "c83d47ab77f17ab6527fe46ff81e9d81d5dcbed4cf4e807e8606548213541da4"

  bottle do
    cellar :any_skip_relocation
    sha256 "cf0bb3d7e03ce83a8b10b07d4370d36abc287f848db489b8a8c34326a5650814" => :catalina
    sha256 "607735a23086bb09d69bbd42dc03bbf28a71b106a825b1b3e6237a295c4bbd00" => :mojave
    sha256 "72169ab43d9ebeca68aa2bb8675c949ec9f7fd41a2b4ffecee890c3ebbb5e9f0" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags", "-s -w", "-trimpath", "-o", bin/"cointop"
    prefix.install_metafiles
  end

  test do
    system bin/"cointop", "test"
  end
end
