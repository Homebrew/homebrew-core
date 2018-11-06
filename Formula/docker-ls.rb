class DockerLs < Formula
  desc "Tools for browsing and manipulating docker registries"
  homepage "https://github.com/mayflower/docker-ls"
  url "https://github.com/mayflower/docker-ls.git",
      :tag      => "v0.3.2",
      :revision => "d371240c3dd46a73f9c516475d5f611c8f699419"

  bottle do
    cellar :any_skip_relocation
    sha256 "13e48e45be8cdb09ff06ca244927b8131debc11b3bc8a31f3d1a1960015024f9" => :mojave
    sha256 "f16bb4511bb3880c9f9dfe114c825f57075ae5524c4e009372a4c9305c236f8d" => :high_sierra
    sha256 "a32421f644c0385dfce1af8091c254502471625cde6ba304cba9dd86f547ada9" => :sierra
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
