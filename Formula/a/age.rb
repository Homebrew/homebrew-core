class Age < Formula
  desc "Simple, modern, secure file encryption"
  homepage "https://github.com/FiloSottile/age"
  url "https://github.com/FiloSottile/age/archive/refs/tags/v1.2.1.tar.gz"
  sha256 "93bd89a16c74949ee7c69ef580d8e4cf5ce03e7d9c461b68cf1ace3e4017eef5"
  license "BSD-3-Clause"
  head "https://github.com/FiloSottile/age.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c690cb985f65f678b227175723ef9bc12ea8c598b9200a8cb2b90cece7e0509e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "705c020da53169d3d628c90d98ffdbd0029da3e3ecfe84cca12a20fa4e0b76a1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "705c020da53169d3d628c90d98ffdbd0029da3e3ecfe84cca12a20fa4e0b76a1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "705c020da53169d3d628c90d98ffdbd0029da3e3ecfe84cca12a20fa4e0b76a1"
    sha256 cellar: :any_skip_relocation, sonoma:        "5e44ff70a1bd1addf97fd49eab60126015d8f477493426a02866b927fa4cc485"
    sha256 cellar: :any_skip_relocation, ventura:       "5e44ff70a1bd1addf97fd49eab60126015d8f477493426a02866b927fa4cc485"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "07553aac53785aceee7c03c807ab7b4d6b90770be185a0888ae7b1b7b635de9a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "216ab3d1d02b2a71ff4003357d434c25d9e0357d7ac18f88ff5de2a645382c59"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.Version=v#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/age"
    system "go", "build", *std_go_args(ldflags:, output: bin/"age-keygen"), "./cmd/age-keygen"

    man1.install "doc/age.1"
    man1.install "doc/age-keygen.1"
  end

  test do
    system bin/"age-keygen", "-o", "key.txt"
    pipe_output("#{bin}/age -e -i key.txt -o test.age", "test", 0)
    assert_equal "test", shell_output("#{bin}/age -d -i key.txt test.age")
  end
end
