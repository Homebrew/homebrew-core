class Dive < Formula
  desc "Tool for exploring each layer in a docker image"
  homepage "https://github.com/wagoodman/dive"
  url "https://github.com/wagoodman/dive/archive/refs/tags/v0.13.1.tar.gz"
  sha256 "2a9666e9c3fddd5e2e5bad81dccda520b8102e7cea34e2888f264b4eb0506852"
  license "MIT"
  head "https://github.com/wagoodman/dive.git", branch: "main"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a2a98b730f1f2fdd600b00603db02e66f43334a703e3e42f7ea019e333d9c426"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a2a98b730f1f2fdd600b00603db02e66f43334a703e3e42f7ea019e333d9c426"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a2a98b730f1f2fdd600b00603db02e66f43334a703e3e42f7ea019e333d9c426"
    sha256 cellar: :any_skip_relocation, sonoma:        "2a6716f77316ff980b2a7b4bf794192abdf9e135968eed6dc486d4528478c272"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "964ca148b9e1b73a5565a266db9a61678e145666d9326c6bd86aaa521ec3a8f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ea8b52ef11f336b96dcf14916b461f5da574a13da8e7fa6b29d12a058646af2e"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")

    generate_completions_from_executable(bin/"dive", shell_parameter_format: :cobra)
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
