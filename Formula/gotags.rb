class Gotags < Formula
  desc "Tag generator for Go, compatible with ctags"
  homepage "https://github.com/jstemmer/gotags"
  url "https://github.com/jstemmer/gotags/archive/v1.4.1.tar.gz"
  sha256 "2df379527eaa7af568734bc4174febe7752eb5af1b6194da84cd098b7c873343"
  license "MIT"
  head "https://github.com/jstemmer/gotags.git"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5ea97844e0e99ab34a8e1efa76325fc7550a737d4bde6c0af1a36fe3b93ce7f9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2bb7b2f4eda136713179e19853088af77dff04472ac4efc25fa0e48648398547"
    sha256 cellar: :any_skip_relocation, monterey:       "703f8c955b818375693bbc165872b0253d9aedcff2c25cad5aeafc2d0e37448d"
    sha256 cellar: :any_skip_relocation, big_sur:        "fc346e7abc09f27730ca2face102e704855a4e105310b27d0dc25b465e8fb453"
    sha256 cellar: :any_skip_relocation, catalina:       "c1b5430e2c3544fc021bc9bbc35c33a1f2c4482a30dbbc8d4977c1f0ee5638a1"
    sha256 cellar: :any_skip_relocation, mojave:         "4413278c3b7f4d8783b9009a986dc91a2a5d3749430105a4297f2cec960a5344"
    sha256 cellar: :any_skip_relocation, high_sierra:    "095f81ef736207a6806af1613a7ab5a0ba3837b4f94f85260aa1bceba3535fea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3ab74768df76e27509e7b8b1739646d0cbbc721f4004e98f56711f837f9d9cb9"
  end

  depends_on "go" => :build

  def install
    ENV["GO111MODULE"] = "auto"
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

    assert_match(/^Bar.*test.go.*$/, shell_output("#{bin}/gotags #{testpath}/test.go"))
  end
end
