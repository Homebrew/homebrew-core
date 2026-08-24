class Leaf < Formula
  desc "General purpose reloader for all projects"
  homepage "https://pkg.go.dev/github.com/vrongmeal/leaf"
  url "https://github.com/vrongmeal/leaf/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "00ba86c1670e4a547d6f584350d41d174452d0679be25828e7835a8da1fe100a"
  license "MIT"
  head "https://github.com/vrongmeal/leaf.git", branch: "master"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9ebb44dcb74ad80d90acb4b54b656e836b214a3de0bfa14e4121324a65de2015"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9ebb44dcb74ad80d90acb4b54b656e836b214a3de0bfa14e4121324a65de2015"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9ebb44dcb74ad80d90acb4b54b656e836b214a3de0bfa14e4121324a65de2015"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3c0e27908c6af5b51c424bfd428b446c7ce96091cf0240a707d429039b0991da"
    sha256 cellar: :any,                 x86_64_linux:  "56e5014d28745e5755f1823813e15924744302bd393ffc58ede0821c402fbf4e"
  end

  deprecate! date: "2026-08-23", because: :unmaintained
  disable! date: "2027-08-23", because: :unmaintained

  depends_on "go" => :build

  # Failing on Intel macOS with Go 1.27 due to outdated golang.org/x/sys dependency
  on_macos do
    depends_on arch: :arm64
  end

  conflicts_with "leaf-markdown-viewer", because: "both install `leaf` binaries"
  conflicts_with "leaf-proxy", because: "both install `leaf` binaries"

  def install
    system "go", "build", *std_go_args, "./cmd/leaf/main.go"
  end

  test do
    (testpath/"a").write "foo"
    spawn bin/"leaf", "-f", "+ a", "-x", "cp a b"
    sleep 1

    assert_equal "foo", (testpath/"b").read
    (testpath/"a").append_lines "bar"
    sleep 1

    assert_equal "foobar\n", (testpath/"b").read
  end
end
