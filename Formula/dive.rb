class Dive < Formula
  desc "Tool for exploring each layer in a docker image"
  homepage "https://github.com/wagoodman/dive"
  url "https://github.com/wagoodman/dive.git",
    :tag      => "v0.9.2",
    :revision => "0872cc18d44a96ed9f59202ac95c556f7e7919a7"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "40f8ae5dc1ace5e588ddfec9355e9a0377929ffa13b2480c1220aca2cd1ec718" => :catalina
    sha256 "278e4cd358ae21365dc261a623f2dc976f0467ad56e352eadec9dac4de568fc9" => :mojave
    sha256 "34dcd82075559df6a0a47081c7860cfc3450f58284ab0abff694f69d48df9f28" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags", "-s -w -X main.version=#{version}", "-trimpath", "-o", bin/"dive"
    prefix.install_metafiles
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
