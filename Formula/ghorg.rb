class Ghorg < Formula
  desc "Quickly clone an entire org's or user's repositories into one directory"
  homepage "https://github.com/gabrie30/ghorg"
  url "https://github.com/gabrie30/ghorg/archive/refs/tags/v1.9.4.tar.gz"
  sha256 "4dcfca1e68ae577e9acf90f4e2f904d6f4997c49a25ac53b056b57b33dd15c7a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "969ac411325fbe7c745e92830dde8798a629717d73e866cf55e4803bd16547df"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ea8cab4ab82afa9a48752c67e1334484268fa82f6c6efc1171b34db20b64d2d6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fcfdb7d96c9dad158b530374c8b023b4e7e6bf44ec41016fa354881b631f02ec"
    sha256 cellar: :any_skip_relocation, ventura:        "df89f2e8eab56c7fe85227f8c04e9e7de88ba2e3e6af480f93ec67f1bc03c464"
    sha256 cellar: :any_skip_relocation, monterey:       "81658502763f88dffcac378a318fbed565b71dcc9e3845d4d952852555eeda76"
    sha256 cellar: :any_skip_relocation, big_sur:        "ce4750c13d4c4fd71b37eec3025da73f85b255e85366a7fb2da27c3a4b9b2ef9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fef67608848e8d9494160327a7746ddc3858c48253a08005327b388e0238596e"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"ghorg", "completion")
  end

  test do
    assert_match "No clones found", shell_output("#{bin}/ghorg ls")
  end
end
