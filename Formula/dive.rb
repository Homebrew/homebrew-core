class Dive < Formula
  desc "Tool for exploring each layer in a docker image"
  homepage "https://github.com/wagoodman/dive"
  url "https://github.com/wagoodman/dive.git",
    :tag      => "v0.9.1",
    :revision => "bfcfc54ee34b623274a91ca48379ac229b5415c2"

  bottle do
    cellar :any_skip_relocation
    sha256 "ca95c04566151ebd4ef7b16505c825aefc109fe5c5b8994c43c9e37e00f34fca" => :catalina
    sha256 "83a9ca47c8ada30d73177485c3b660b8815cbce9bdd71fe9d713ee4de195ffc2" => :mojave
    sha256 "4c2b212f5447326dc667753c289fe3192719515bed98102ec4061f8be5631005" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath

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
