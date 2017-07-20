class Kompose < Formula
  desc "Tool to move from `docker-compose` to Kubernetes"
  homepage "http://kompose.io"
  url "https://github.com/kubernetes/kompose/archive/v1.0.0.tar.gz"
  sha256 "b9c9bfc9f25c67cf7d8d8b76467487255f9882fca563f8e9ef990f647cd2406e"

  bottle do
    cellar :any_skip_relocation
    sha256 "8d1f927f25eaea188d4d72e01b2ac4114a9f27777b00f8be429fff3ee32037c2" => :sierra
    sha256 "1053cb76c50c63737f83c81e499f0a89c20aa01d20e32a13e9aa1af021e9f603" => :el_capitan
    sha256 "1c09acd079b72b6af858ae8ce3bc3097161a04e2c2cc62decf8d9b2aca1d2e55" => :yosemite
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    mkdir_p buildpath/"src/github.com/kubernetes"
    ln_s buildpath, buildpath/"src/github.com/kubernetes/kompose"
    system "make", "bin"
    bin.install "kompose"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kompose version")
  end
end
