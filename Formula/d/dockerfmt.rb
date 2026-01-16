class Dockerfmt < Formula
  desc "Dockerfile format and parser. a modern dockfmt"
  homepage "https://github.com/reteps/dockerfmt"
  url "https://github.com/reteps/dockerfmt/archive/refs/tags/v0.3.9.tar.gz"
  sha256 "a156f43b62168531f999f4ee1fb39b6d0057e55e4f703c96181be32950b3c461"
  license "MIT"
  head "https://github.com/reteps/dockerfmt.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "101a5934baacdd9c0eab3b1e9b335818dc1e5938b2cb264183cfa1a8f6dc455a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "101a5934baacdd9c0eab3b1e9b335818dc1e5938b2cb264183cfa1a8f6dc455a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "101a5934baacdd9c0eab3b1e9b335818dc1e5938b2cb264183cfa1a8f6dc455a"
    sha256 cellar: :any_skip_relocation, sonoma:        "08923cd6b556ad3c8d58ca04e7eda92aae0f5a6d167b275427e09d71c881fd30"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c551d692a59672c995321da96c3209cc3265c9cac3bb69b9e394483201d3a0de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dfc5c09a56b3ab87c3a096c66965cedbd1ac51e6322334ec271454b52b9d0931"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
    generate_completions_from_executable(bin/"dockerfmt", shell_parameter_format: :cobra)
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
