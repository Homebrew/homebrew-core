class Dive < Formula
  desc "Tool for exploring each layer in a docker image"
  homepage "https://github.com/wagoodman/dive"
  url "https://github.com/wagoodman/dive.git",
    :tag      => "v0.7.2",
    :revision => "09296c0214c4cc7477fe53bc79c54805899c6d19"

  bottle do
    cellar :any_skip_relocation
    sha256 "47366221b4f7e6ebdc7c89f6dd620e9615154aef174d4e1e55fd93007c991dea" => :mojave
    sha256 "f2a31f3886bb3ebb8fd834f5712882b3fedcb2fb16e590b0be2b13eda3f3294b" => :high_sierra
    sha256 "f1fa1a7e1c7082e513977ea1d9974aaa0263fa3abe3b8db5156de71e2287aafb" => :sierra
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
