class Dive < Formula
  desc "Tool for exploring each layer in a docker image"
  homepage "https://github.com/wagoodman/dive"
  url "https://github.com/wagoodman/dive.git",
    :tag      => "v0.7.2",
    :revision => "09296c0214c4cc7477fe53bc79c54805899c6d19"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "d8e19fe2565174d6d2a7b2b247aa1f62a63ca7394856c218878115619ef6c439" => :mojave
    sha256 "b207a956d663539670ed7dec54a5543a20720dabc926b22326751af106af4194" => :high_sierra
    sha256 "34f300558c0794d99d71823cfe87ad8c3b0e3ef84e59f64cee0a5af860711b51" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "on"

    dir = buildpath/"src/github.com/wagoodman/dive"
    dir.install buildpath.children

    cd dir do
      system "go", "build", "-ldflags", "-s -w -X main.version=#{version}", "-o", bin/"dive"
      prefix.install_metafiles
    end
  end

  test do
    (testpath/"Dockerfile").write <<~EOS
      FROM alpine
      ENV test=homebrew-core
      RUN echo "hello"
    EOS

    assert_match "dive #{version}", shell_output("#{bin}/dive version")

    assert_match "Building image", shell_output("CI=true #{bin}/dive build .", 1)
  end
end
