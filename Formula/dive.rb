class Dive < Formula
  desc "Tool for exploring each layer in a docker image"
  homepage "https://github.com/wagoodman/dive"
  url "https://github.com/wagoodman/dive.git",
    :tag      => "v0.8.1",
    :revision => "f2ea8b503d3cb06d1be611dcb32f0ef6b161b511"

  bottle do
    cellar :any_skip_relocation
    sha256 "fcff37f6efea602e0909136a76cbdeef185f6097ae5d8c1362e42b2137648768" => :mojave
    sha256 "7c194d07ddf7f27bf792dddd5efebedd70e183c6680fe786e4a774e7d25c4e8d" => :high_sierra
    sha256 "1f8cbf97ea22b6ab7ee29dc31c1c2c54e0cb5ad22cc08ed8b4d108a81a4252ac" => :sierra
  end

  depends_on "go" => :build

  # Remove this patch in the next version.
  patch do
    url "https://github.com/wagoodman/dive/commit/f48715d4c536fdaf0ec57277f2677e4ed8076ad3.patch?full_index=1"
    sha256 "e13be53a71bca7e5393f7a1cdbbcb2691470be9227e384dc7c97b2bb1b49a40c"
  end

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
