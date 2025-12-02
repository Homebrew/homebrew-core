class Dive < Formula
  desc "Tool for exploring each layer in a docker image"
  homepage "https://github.com/wagoodman/dive"
  url "https://github.com/wagoodman/dive/archive/refs/tags/v0.13.1.tar.gz"
  sha256 "2a9666e9c3fddd5e2e5bad81dccda520b8102e7cea34e2888f264b4eb0506852"
  license "MIT"
  head "https://github.com/wagoodman/dive.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "00d8433629c5c4443ecb454b41ccb295755621da4712dd763c4d13186f0293e1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "00d8433629c5c4443ecb454b41ccb295755621da4712dd763c4d13186f0293e1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "00d8433629c5c4443ecb454b41ccb295755621da4712dd763c4d13186f0293e1"
    sha256 cellar: :any_skip_relocation, sonoma:        "bbf06fc96c2713b5343c153833eb12bb3d78a783e6c20142e43762bed913565a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "395a3a4bb1339f9f99a30fd319a3996d51b68b68e651351d89ee41039f5d3557"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5e56c8da50f1a7d70cf0baebf4ca0776269c7aef34928fab7206b6691d245ea3"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")

    generate_completions_from_executable(bin/"dive", "completion")
  end

  test do
    (testpath/"Dockerfile").write <<~DOCKERFILE
      FROM alpine
      ENV test=homebrew-core
      RUN echo "hello"
    DOCKERFILE

    assert_match "dive #{version}", shell_output("#{bin}/dive version")
    assert_match "Building image", shell_output("CI=true #{bin}/dive build .", 1)
  end
end
