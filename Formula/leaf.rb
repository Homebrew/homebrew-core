class Leaf < Formula
  desc "General purpose reloader for all projects"
  homepage "https://pkg.go.dev/github.com/vrongmeal/leaf"
  url "https://github.com/vrongmeal/leaf/archive/v1.3.0.tar.gz"
  sha256 "00ba86c1670e4a547d6f584350d41d174452d0679be25828e7835a8da1fe100a"
  license "MIT"
  head "https://github.com/vrongmeal/leaf.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "05134aed065b97e8a0f03a5a7103b91e1e212267e3f015e06c094f35e00f0404" => :big_sur
    sha256 "92383edde853bff3ca30232ad54a8508d9f73b33b6fb5279402c564835f3bfaf" => :arm64_big_sur
    sha256 "ff2197a6b53db4ed452c5abaf4279ad46b2c0ad48b82b07680c04d13a7163cba" => :catalina
    sha256 "8c1fa1f81a61baf2e78c9afaf0b82704086e9d082a8660e4548d1a0786871a37" => :mojave
    sha256 "bb124d36d6bef75d7005792079f9b08ebbe4cd858469d1efe6d464865d351b6d" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./cmd/leaf/main.go"
  end

  test do
    (testpath/"a").write "foo"
    fork do
      exec bin/"leaf", "-f", "+ a", "-x", "cp a b"
    end
    sleep 1

    assert_equal (testpath/"a").read, (testpath/"b").read
    (testpath/"a").append_lines "bar"
    sleep 1

    assert_equal (testpath/"a").read, (testpath/"b").read
  end
end
