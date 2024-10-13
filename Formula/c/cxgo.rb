class Cxgo < Formula
  desc "Transpiling C to Go"
  homepage "https://github.com/gotranspile/cxgo"
  url "https://github.com/gotranspile/cxgo/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "d17a69ae9d6bc96341a989d0f673f1f6b8f65686987ddbe4c903b571e56c665f"
  license "MIT"
  head "https://github.com/gotranspile/cxgo.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "e163f483caad70b6344b38981743602b65c9250361dd6470908f8140608aaf84"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bed5ef0e2d7d6f45377b192e8abcc594ad9b3cd763905ae28093c54598cf88a4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c16827d8dfadf869da239e7abd54cd2868eed4abbb4b027b3ee00c37893ee8f7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "71999929e1355bbe9c8b119dde56c7a39006abc44a91cc1b83fc71717d507fa7"
    sha256 cellar: :any_skip_relocation, sonoma:         "ccdb1b1538ea5be8610c8afdb399da9bc8754514b4a4658b41dfaf90727e8e05"
    sha256 cellar: :any_skip_relocation, ventura:        "cf4dd149ddba8b895c4ff91b69bcd0eca0726935010f0dd3fad497087cfdda6a"
    sha256 cellar: :any_skip_relocation, monterey:       "19b69309d1dedbb456c32573d64771b0529158dad1dddf4f52b0f990da99e7bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "26ef72201e83ff7d5c5409e6eef61999a44d60771c5829839f55966b8abdb289"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{tap.user}
      -X main.date=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/cxgo"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      int main() {
        printf("Hello, World!");
        return 0;
      }
    EOS

    expected = <<~EOS
      package main

      import (
      \t"github.com/gotranspile/cxgo/runtime/stdio"
      \t"os"
      )

      func main() {
      \tstdio.Printf("Hello, World!")
      \tos.Exit(0)
      }
    EOS

    system bin/"cxgo", "file", testpath/"test.c"
    assert_equal expected, (testpath/"test.go").read

    assert_match version.to_s, shell_output("#{bin}/cxgo version")
  end
end
