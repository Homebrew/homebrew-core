class Dive < Formula
  desc "Tool for exploring each layer in a docker image"
  homepage "https://github.com/wagoodman/dive"
  url "https://github.com/wagoodman/dive.git",
    tag:      "v0.9.2",
    revision: "0872cc18d44a96ed9f59202ac95c556f7e7919a7"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "bb8417748b9d7e9199951eccdeb6892e468721480b5b639e94bee7541cfdf25c" => :catalina
    sha256 "12d537965d7d988136ff5aa24f002dbf8ce1a161f30e89167d7c1262ac1346c8" => :mojave
    sha256 "8ad8419f3ac59cb8b3e1627c0c329d773a1c6583e10693441a49a5f66c1efc71" => :high_sierra
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
