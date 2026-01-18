class Gotests < Formula
  desc "Automatically generate Go test boilerplate from your source code"
  homepage "https://github.com/cweill/gotests"
  url "https://github.com/cweill/gotests/archive/refs/tags/v1.9.0.tar.gz"
  sha256 "1a36874dd5beec211e9b9aaf7d72be8839e76b5ad0a002cb4e83b80ad948697b"
  license "Apache-2.0"
  head "https://github.com/cweill/gotests.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9df20fdd667942ed0db364896b9d3ec5dea05ba66569cf265319c892bf16922a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9df20fdd667942ed0db364896b9d3ec5dea05ba66569cf265319c892bf16922a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9df20fdd667942ed0db364896b9d3ec5dea05ba66569cf265319c892bf16922a"
    sha256 cellar: :any_skip_relocation, sonoma:        "cfa2259d33d113f8a7800ca1ea057cf0aba2025bf27f9c76a298e66bdbc475da"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e0c504b5b5866a465e6ee748d60d33cc96f65af20f7270c8db0c6d4291c948f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7ac759554a3d2758bc73f3f0fe37bf65cc2f75e02adbc876a01b4378e073a87d"
  end

  depends_on "go" => [:build, :test]

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./gotests"
  end

  test do
    (testpath/"test.go").write <<~GO
      package main

      func add(x int, y int) int {
      	return x + y
      }
    GO
    expected = <<~EOS
      Generated Test_add
      package main

      import "testing"

      func Test_add(t *testing.T) {
      	type args struct {
      		x int
      		y int
      	}
      	tests := []struct {
      		name string
      		args args
      		want int
      	}{
      		// TODO: Add test cases.
      	}
      	for _, tt := range tests {
      		t.Run(tt.name, func(t *testing.T) {
      			if got := add(tt.args.x, tt.args.y); got != tt.want {
      				t.Errorf("add() = %v, want %v", got, tt.want)
      			}
      		})
      	}
      }
    EOS
    assert_equal expected, shell_output("#{bin}/gotests -all test.go")
  end
end
