class Dive < Formula
  desc "Tool for exploring each layer in a docker image"
  homepage "https://github.com/wagoodman/dive"
  url "https://github.com/wagoodman/dive.git",
    :tag      => "v0.9.0",
    :revision => "0b147b0f6098b519d2e57c2aa74646dfbf95ab85"

  bottle do
    cellar :any_skip_relocation
    sha256 "94f8a800872f594e4e59afc0b7350135d6457470267d67f1bcf5239c43585d40" => :catalina
    sha256 "fcff37f6efea602e0909136a76cbdeef185f6097ae5d8c1362e42b2137648768" => :mojave
    sha256 "7c194d07ddf7f27bf792dddd5efebedd70e183c6680fe786e4a774e7d25c4e8d" => :high_sierra
    sha256 "1f8cbf97ea22b6ab7ee29dc31c1c2c54e0cb5ad22cc08ed8b4d108a81a4252ac" => :sierra
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
