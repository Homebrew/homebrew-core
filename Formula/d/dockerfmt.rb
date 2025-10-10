class Dockerfmt < Formula
  desc "Dockerfile format and parser. a modern dockfmt"
  homepage "https://github.com/reteps/dockerfmt"
  license "MIT"
  head "https://github.com/reteps/dockerfmt.git", branch: "main"

  stable do
    url "https://github.com/reteps/dockerfmt/archive/refs/tags/v0.3.8.tar.gz"
    sha256 "d1cf00967f80a4228c01fc113c10348d1b69c2e7c4e48704df058b3c95093e4b"

    # version patch
    patch do
      url "https://github.com/reteps/dockerfmt/commit/5dfcd5f7afd2d04d75488963f8a15e954b97828a.patch?full_index=1"
      sha256 "8bf1b7612cd0d845c8dd7ae10f43b815a5c13d1d0dfd120d76f8deab37e9f7bc"
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4b2931df2b05848a2fab07c0e3e6b01cf62c06f5401a776144b0b675c973ff8d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4b2931df2b05848a2fab07c0e3e6b01cf62c06f5401a776144b0b675c973ff8d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4b2931df2b05848a2fab07c0e3e6b01cf62c06f5401a776144b0b675c973ff8d"
    sha256 cellar: :any_skip_relocation, sonoma:        "c5e5c4808cc9bc5dbc7167e02c8f55362209816c4bb83de409e878542ae972f3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d481bb9e327635268567bb842c14440013834c7766f368fbea140d8e3d350a1a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "34f32da196d27fae08da34dc8882d1001012aa46140dae46cbd250d6d433074c"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
    generate_completions_from_executable(bin/"dockerfmt", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dockerfmt version")

    (testpath/"Dockerfile").write <<~DOCKERFILE
      FROM alpine:latest
    DOCKERFILE

    output = shell_output("#{bin}/dockerfmt --check Dockerfile 2>&1", 1)
    assert_match "Dockerfile is not formatted", output
  end
end
