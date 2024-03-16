class Fx < Formula
  desc "Terminal JSON viewer"
  homepage "https://fx.wtf"
  url "https://github.com/antonmedv/fx/archive/refs/tags/33.0.0.tar.gz"
  sha256 "b619c18a3cbc7566be1c7fecfc802d469402cf8eae6a70911359c4de7eab07ba"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ad64cee290bb9f1eae356ae2bef4e488bcd339ef72b49dad2cb9a6ab501e429c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ad64cee290bb9f1eae356ae2bef4e488bcd339ef72b49dad2cb9a6ab501e429c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ad64cee290bb9f1eae356ae2bef4e488bcd339ef72b49dad2cb9a6ab501e429c"
    sha256 cellar: :any_skip_relocation, sonoma:         "e5445c876ec3cc5e620e9c2e6516559a54abecb94e8aac7a4065719220d83a1a"
    sha256 cellar: :any_skip_relocation, ventura:        "e5445c876ec3cc5e620e9c2e6516559a54abecb94e8aac7a4065719220d83a1a"
    sha256 cellar: :any_skip_relocation, monterey:       "e5445c876ec3cc5e620e9c2e6516559a54abecb94e8aac7a4065719220d83a1a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7d0a7e8e75fd42c694101bc6b7aac7022f133c5467f4aa6ae92be9661d6db9dd"
  end

  depends_on "go" => :build
  depends_on "node"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_equal "42", pipe_output("#{bin}/fx .", 42).strip
  end
end
