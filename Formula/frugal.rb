class Frugal < Formula
  desc "Cross language code generator for creating scalable microservices"
  homepage "https://github.com/Workiva/frugal"
  url "https://github.com/Workiva/frugal/archive/v3.16.8.tar.gz"
  sha256 "ca1bcf131b12a8eae69c091a6582a3f880c93fb9966e2bd7b52e537385982349"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ccbeb121ca1bc2ec70de5c1bade43f71cd560cdb7a83ffdd2052c0dab0d903eb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "92df87cf9331c998f9454ed76f04dce7b3e762cca8945e66f12efc97742118c5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0b0fdb560fb99d05b97d58e4e210832c06f4ad6c8d3d2c869da6e32f38b96664"
    sha256 cellar: :any_skip_relocation, ventura:        "e78b81a9da4d20678198a69e0e3702897daf8a463df960247088a75006f680d9"
    sha256 cellar: :any_skip_relocation, monterey:       "09fec284081320d45eb6a76dcb833a1903e1fa0166229367db077aba5a9d885a"
    sha256 cellar: :any_skip_relocation, big_sur:        "16070448adf68c04d6f9a3d50d52e6d0b77740410ebfee2c6bff9014a1f2915f"
    sha256 cellar: :any_skip_relocation, catalina:       "890d9d7f0f0f834c0d108dd79e9edf31ecb834337a005ec458099e460d0cba8a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0ef231df771ac9b89a3f5b40722e9c673d811ba2c540d6bb511cdacbf0c47c02"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    (testpath/"test.frugal").write("typedef double Test")
    system "#{bin}/frugal", "--gen", "go", "test.frugal"
    assert_match "type Test float64", (testpath/"gen-go/test/f_types.go").read
  end
end
