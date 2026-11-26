class Gotests < Formula
  desc "Automatically generate Go test boilerplate from your source code"
  homepage "https://github.com/cweill/gotests"
  url "https://github.com/cweill/gotests/archive/refs/tags/v1.10.0.tar.gz"
  sha256 "9a2261435dae1002bafa596be86ab50b180f4d4642ed5bc293471a2c150b8115"
  license "Apache-2.0"
  head "https://github.com/cweill/gotests.git", branch: "develop"

  bottle do
    manifest_sha256 "7c117481a55087475741c7472e7a4bfd5b5fee2eeecff1ba6e89e32fce5d751d"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d6763f50ae384e7857d6c32b6d7d5ac18063c39457aa5d2dd2c00898328441d0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d6763f50ae384e7857d6c32b6d7d5ac18063c39457aa5d2dd2c00898328441d0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d6763f50ae384e7857d6c32b6d7d5ac18063c39457aa5d2dd2c00898328441d0"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "df0855fd02c736b190a03a0654fe935aefd627efb36d705fcdf153ccf7e3912d"
    sha256 cellar: :any,                 x86_64_linux:      "13c8eab06b4412c833fbaa45cf950fe79207848d8af88dfe8c835db504b5bf2c"
  end

  depends_on "go" => [:build, :test]

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args, "./gotests"
  end

  test do
    (testpath/"test.go").write <<~GO
      package main

      func add(x int, y int) int {
      	return x + y
      }
    GO
    expected = <<~GO
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
    GO
    assert_equal expected, shell_output("#{bin}/gotests -all test.go")
  end
end
