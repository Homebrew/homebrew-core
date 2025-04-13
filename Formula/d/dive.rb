class Dive < Formula
  desc "Tool for exploring each layer in a docker image"
  homepage "https://github.com/wagoodman/dive"
  url "https://github.com/wagoodman/dive/archive/refs/tags/v0.13.1.tar.gz"
  sha256 "2a9666e9c3fddd5e2e5bad81dccda520b8102e7cea34e2888f264b4eb0506852"
  license "MIT"
  head "https://github.com/wagoodman/dive.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f09a27e21a4b76122d74e9a776219ab7377efaf30dff7d8d7e3016aac375d14a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f09a27e21a4b76122d74e9a776219ab7377efaf30dff7d8d7e3016aac375d14a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f09a27e21a4b76122d74e9a776219ab7377efaf30dff7d8d7e3016aac375d14a"
    sha256 cellar: :any_skip_relocation, sonoma:        "676549efe805835ddb82aed795bd168b5ea9bb07ffbdb6500965c59474e035ca"
    sha256 cellar: :any_skip_relocation, ventura:       "676549efe805835ddb82aed795bd168b5ea9bb07ffbdb6500965c59474e035ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a0eea0c4d2dc63bfa43c121fc136bd18ba3b1fed57f5e3aedae0ca2c57b35097"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")
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
