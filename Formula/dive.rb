class Dive < Formula
  desc "Tool for exploring each layer in a docker image"
  homepage "https://github.com/wagoodman/dive"
  url "https://github.com/wagoodman/dive.git",
    :tag      => "v0.7.2",
    :revision => "09296c0214c4cc7477fe53bc79c54805899c6d19"

  depends_on "go" => :build
  depends_on "docker"

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
