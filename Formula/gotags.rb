class Gotags < Formula
  desc "ctags-compatible tag generator for Go"
  homepage "https://github.com/jstemmer/gotags"
  url "https://github.com/jstemmer/gotags/archive/v1.4.1.tar.gz"
  sha256 "2df379527eaa7af568734bc4174febe7752eb5af1b6194da84cd098b7c873343"

  head "https://github.com/jstemmer/gotags.git"

  bottle do
    cellar :any_skip_relocation
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
    (testpath/"test.go").write <<-EOS.undent
      package main

      type Foo struct {
          Bar int
      }
    EOS

    assert_match /^Bar.*test.go.*$/, shell_output("#{bin}/gotags #{testpath}/test.go")
  end
end
