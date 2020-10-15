class Gotags < Formula
  desc "Tag generator for Go, compatible with ctags"
  homepage "https://github.com/jstemmer/gotags"
  url "https://github.com/jstemmer/gotags/archive/v1.4.1.tar.gz"
  sha256 "2df379527eaa7af568734bc4174febe7752eb5af1b6194da84cd098b7c873343"
  license "MIT"
  head "https://github.com/jstemmer/gotags.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "c1b5430e2c3544fc021bc9bbc35c33a1f2c4482a30dbbc8d4977c1f0ee5638a1" => :catalina
    sha256 "4413278c3b7f4d8783b9009a986dc91a2a5d3749430105a4297f2cec960a5344" => :mojave
    sha256 "095f81ef736207a6806af1613a7ab5a0ba3837b4f94f85260aa1bceba3535fea" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags", "-s -w", "-trimpath", "-o", bin/"gotags"
    prefix.install_metafiles
  end

  test do
    (testpath/"test.go").write <<~EOS
      package main

      type Foo struct {
          Bar int
      }
    EOS

    assert_match /^Bar.*test.go.*$/, shell_output("#{bin}/gotags #{testpath}/test.go")
  end
end
