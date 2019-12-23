class JfrogCliGo < Formula
  desc "Command-line interface for Jfrog Artifactory and Bintray"
  homepage "https://github.com/jfrog/jfrog-cli"
  url "https://github.com/JFrog/jfrog-cli-go/archive/1.32.3.tar.gz"
  sha256 "ece78de9597b6c1865c58e4f7702e8dab4eb5afec3ed279f57058930206e57c7"

  bottle do
    cellar :any_skip_relocation
    sha256 "fd10d11e37e0a9e03b0b5c2d60f13ab1045a45f2d433a29f29374d5542906ce0" => :catalina
    sha256 "3fab1aafcd2481fc7f65f012fe14374a6ae96eee21abf21b50b1934a4ea88983" => :mojave
    sha256 "bc687cc547f03f9c8394ba58e914fe62fa7636491f8b8aee617b76df234ff7eb" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "run", "./python/addresources.go"
    system "go", "build", "-ldflags", "-s -w -extldflags '-static'", "-trimpath", "-o", bin/"jfrog"
    prefix.install_metafiles
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jfrog -v")
  end
end
