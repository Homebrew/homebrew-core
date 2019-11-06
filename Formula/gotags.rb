class Gotags < Formula
  desc "Tag generator for Go, compatible with ctags"
  homepage "https://github.com/jstemmer/gotags"
  url "https://github.com/jstemmer/gotags/archive/v1.4.1.tar.gz"
  sha256 "2df379527eaa7af568734bc4174febe7752eb5af1b6194da84cd098b7c873343"
  head "https://github.com/jstemmer/gotags.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "13b791fb6a1e4e3050b445acf2c8f4cce422ac3e03495de4b7ff306307ee8715" => :catalina
    sha256 "b8c3124d0f0e67708a71445786c2c649cf4aa2da56059c2b28bc0ec73a7a712f" => :mojave
    sha256 "fd44bf7cd73b2fddbe2184c79e3227a1ffd72896958482785c592c22b1186c25" => :high_sierra
    sha256 "1a942b988d0362a034c030a6d5609cdae6edc24a6d8ca21c61eb29e9fe37e194" => :sierra
    sha256 "8f59b1c7639c0d4a8f2ec7a4ec037ed48d365cb1f64a51e7d6704264bc4e840d" => :el_capitan
    sha256 "ecab701e7806da9a5d81977a68460df32a4f15c5d424c396ce52e175d8dbee15" => :yosemite
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath

    system "go", "build", "-o", "gotags"
    bin.install "gotags"
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
