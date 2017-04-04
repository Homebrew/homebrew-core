class Gotags < Formula
  desc "ctags-compatible tag generator for Go"
  homepage "https://github.com/jstemmer/gotags"
  url "https://github.com/jstemmer/gotags/archive/v1.4.1.tar.gz"
  sha256 "2df379527eaa7af568734bc4174febe7752eb5af1b6194da84cd098b7c873343"

  head "https://github.com/jstemmer/gotags.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "69101497dabc6607934235a8ab883935b60dcca5d0c355a58d0d2200203352e0" => :sierra
    sha256 "42c5a4456f915aa0d2d248d1ddbd668356d30e3a4b6859314dbda4fcca715909" => :el_capitan
    sha256 "caa89148a5f0271af601b5843893cbfdfc872bb278350819b6fa12c5ce051535" => :yosemite
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
