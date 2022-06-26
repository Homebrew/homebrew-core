class Gotests < Formula
  desc "Automatically generate Go test boilerplate from your source code"
  homepage "https://github.com/cweill/gotests"
  url "https://github.com/cweill/gotests/archive/refs/tags/v1.6.0.tar.gz"
  sha256 "f0236dbebd8a3fd19ec4260f490cb164240e1d518d3971b42872978f7a50c040"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a2daf6aeff322ba4de342bb2d21b485732ae4851575387860ff91462e14e8d31"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ca761cc187d08b5d211562b383610d614c67a4533de9c552f6e2b57a07b7ed5b"
    sha256 cellar: :any_skip_relocation, monterey:       "cbd11e7ba3400d2a6896974899257d37105759cabebe94bc4a599c739e3ade92"
    sha256 cellar: :any_skip_relocation, big_sur:        "222e2a0280ae3d085bbf76080b9bd30e4fe1e9942a0427dc2840d74337621f76"
    sha256 cellar: :any_skip_relocation, catalina:       "717ea92ad6172ab6ca8987b618683c85f4a576161e78bc75c02000966ea3f9ac"
    sha256 cellar: :any_skip_relocation, mojave:         "41417917289de92b26a9182dec51f9d43dc7bcf9c93eb2751143f5f70ecb0c80"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d2f0b6e37e88deaf7713ebf6a2e34baf767e2a7b6168244f31e909ef4b8f8100"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./gotests"
  end

  test do
    (testpath/"test.go").write <<~EOS
      package main

      func add(x int, y int) int {
      	return x + y
      }
    EOS
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
