class Goreman < Formula
  desc "Foreman clone written in Go"
  homepage "https://github.com/mattn/goreman"
  url "https://github.com/mattn/goreman/archive/v0.3.7.tar.gz"
  sha256 "424dde6592c99468dce19c1302222a15ccc2367f0c908ee2147709398ce6497b"
  license "MIT"
  head "https://github.com/mattn/goreman.git"

  livecheck do
    url :homepage
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "b23fc772de996cff73c26a93ba73c826b5f7e56929f0c717c9388066bb689067"
    sha256 cellar: :any_skip_relocation, big_sur:       "7935ca50f9a9c6fc0caceb81d64a6439aab37c61fb75edbbff99729e3542568b"
    sha256 cellar: :any_skip_relocation, catalina:      "8985d410d3b9c56064ceb7a01be4fd448e46c414f0a0b8c3a4f6ec7374c2f5b6"
    sha256 cellar: :any_skip_relocation, mojave:        "d7781e6ce9c1ab5844f06d77dbbb8355a5f749daa5cd3c2b12266385d73b9a77"
    sha256 cellar: :any_skip_relocation, high_sierra:   "df59dbb8a079d4eaf095b7a807dcbd0a96de11874dec3b6e560454617eed9b2b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "49363f66d05e2aaa57afa85118546980f4dd8be8484f6f862c813613326f83ae"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags", "-s -w", "-trimpath", "-o", bin/"goreman"
  end

  test do
    (testpath/"Procfile").write "web: echo 'hello' > goreman-homebrew-test.out"
    system bin/"goreman", "start"
    assert_predicate testpath/"goreman-homebrew-test.out", :exist?
    assert_match "hello", (testpath/"goreman-homebrew-test.out").read
  end
end
