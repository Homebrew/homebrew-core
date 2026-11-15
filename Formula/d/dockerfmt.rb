class Dockerfmt < Formula
  desc "Dockerfile format and parser. a modern dockfmt"
  homepage "https://github.com/reteps/dockerfmt"
  url "https://github.com/reteps/dockerfmt/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "3bbed8d06a049bac352cbb06b7a369439578896f63a6995d1ac6b52c7b7fed52"
  license "MIT"
  head "https://github.com/reteps/dockerfmt.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0154fa93fb6ac7ae66eec73a78f72928dc3082049e8b26404942e648606f1d66"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "0154fa93fb6ac7ae66eec73a78f72928dc3082049e8b26404942e648606f1d66"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0154fa93fb6ac7ae66eec73a78f72928dc3082049e8b26404942e648606f1d66"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "7c75dee3243b4eb2e9a073071882b62a994407d522a75f78ee0b8b1928d72314"
    sha256 cellar: :any,                 x86_64_linux:      "2f466ea71d7fe36aad5c1c710e0b0d3017cf36a64e5e171c42db9b9223ba08c0"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-X github.com/reteps/dockerfmt/cmd.Version=#{version}")
    generate_completions_from_executable(bin/"dockerfmt", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dockerfmt version")

    (testpath/"Dockerfile").write <<~DOCKERFILE
      from alpine:latest
      run   echo hi
    DOCKERFILE

    shell_output("#{bin}/dockerfmt --check Dockerfile", 1)
    system bin/"dockerfmt", "--write", "Dockerfile"
    assert_equal "FROM alpine:latest\nRUN echo hi\n", (testpath/"Dockerfile").read
    system bin/"dockerfmt", "--check", "Dockerfile"
  end
end
