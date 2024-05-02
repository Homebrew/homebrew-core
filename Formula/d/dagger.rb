class Dagger < Formula
  desc "Portable devkit for CI/CD pipelines"
  homepage "https://dagger.io"
  url "https://github.com/dagger/dagger.git",
      tag:      "v0.11.2",
      revision: "a53b0b7487744dc61902a2bb0f60d69e6c75dd11"
  license "Apache-2.0"
  head "https://github.com/dagger/dagger.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f0995f608e5c99287c814c90a8abb7d512d58c13aef2290a471ed921cf16045e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "25f5166bbc23b195c11f8505620472b4d2b5586953f8e38b9a7426857caab165"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a368905ed9c7bd4b14abde599eebfc4b6076fb7df3b443e1e73fd8786eb2d726"
    sha256 cellar: :any_skip_relocation, sonoma:         "1a4d07a8df1b3ded5fbb63b8eb55645e406a5ea24422717f6dfadb92b083ed48"
    sha256 cellar: :any_skip_relocation, ventura:        "53a76f1cdef2fc7a50cd18d804a27a8b553b5c7f5ddb2f4d4df4fdc712bd3c53"
    sha256 cellar: :any_skip_relocation, monterey:       "d5a866125e5763ec72ad625af1f691fe6f53e4002c5ed1db8b3e2ec8ddef4ca7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "af7a17a8bb9bd77f547e35c960deec3663b4e67dee0c5b642dd6e933386c4c36"
  end

  depends_on "go" => :build
  depends_on "docker" => :test

  def install
    ldflags = %W[
      -s -w
      -X github.com/dagger/dagger/engine.Version=v#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/dagger"

    generate_completions_from_executable(bin/"dagger", "completion")
  end

  test do
    ENV["DOCKER_HOST"] = "unix://#{testpath}/invalid.sock"

    assert_match "dagger v#{version}", shell_output("#{bin}/dagger version")

    output = shell_output("#{bin}/dagger query brewtest 2>&1", 1)
    assert_match "Cannot connect to the Docker daemon", output
  end
end
