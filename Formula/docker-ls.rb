class DockerLs < Formula
  desc "Tools for browsing and manipulating docker registries"
  homepage "https://github.com/mayflower/docker-ls"
  url "https://github.com/mayflower/docker-ls.git",
      :tag      => "v0.3.1",
      :revision => "d80310976c9707e261e57ebfa9acf4e0b1781460"

  bottle do
    cellar :any_skip_relocation
    sha256 "eb0ddf264090d9380c760768d5e46c970b43b1c73256e4c899cfeaf5a3dcdad8" => :mojave
    sha256 "946e27ec3c35ec19d98c1a8efdf59a809db23926f97d3cd98b195d15c28491cd" => :high_sierra
    sha256 "1815a65eab86116dfc1de21331352348d59f391cdbc2ed1454a1847f62b21845" => :sierra
    sha256 "d011c19d2e36dd798ffa5723448cfeb1d95c25b7e78ad4b64207f4c79c5be383" => :el_capitan
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
