class DockerLs < Formula
  desc "Tools for browsing and manipulating docker registries"
  homepage "https://github.com/mayflower/docker-ls"
  url "https://github.com/mayflower/docker-ls.git",
      tag:      "v0.4.1",
      revision: "6b43cadf58018486a517274608b3fb7f857d8f62"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "45b8b6a4661e9aef6574de79da054c373d556fa98552c51fb5ca59892a497bbd" => :big_sur
    sha256 "56dacd445e747685722b7da1588eeaccca5c3a1ddcba993985174966ef508322" => :catalina
    sha256 "1fdc6a0f24b89ea626a526f22d9c4c203645654c33128f51cb9067305a1fa62e" => :mojave
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath

    (buildpath/"src/github.com/mayflower/docker-ls").install buildpath.children

    system "go", "generate", "github.com/mayflower/docker-ls/lib"

    cd "src/github.com/mayflower/docker-ls" do
      system "go", "build", "-o", bin/"docker-ls", "./cli/docker-ls"
      system "go", "build", "-o", bin/"docker-rm", "./cli/docker-rm"
      prefix.install_metafiles
    end
  end

  test do
    assert_match /\Wlatest\W/m, pipe_output("#{bin}/docker-ls tags \
      -r https://index.docker.io -u '' -p '' \
      --progress-indicator=false library/busybox \
    ")

    assert_match /401/, pipe_output("#{bin}/docker-rm  \
      -r https://index.docker.io -u foo -p bar library/busybox:latest 2<&1 \
    ")
  end
end
