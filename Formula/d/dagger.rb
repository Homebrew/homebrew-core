class Dagger < Formula
  desc "Portable devkit for CI/CD pipelines"
  homepage "https://dagger.io"
  url "https://github.com/dagger/dagger.git",
      tag:      "v0.9.5",
      revision: "9ea5ea7c848fef2a2c47cce0716d5fcb8d6bedeb"
  license "Apache-2.0"
  head "https://github.com/dagger/dagger.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "57290615a4c61d2b2b7a270a01d67ea8acb20ebc8eebc171a37089bb3442d67b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1f4819ddd43ddda02411bf2d8a09f8f22326f60beb5746a4be0c0e20c1a48dea"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "370d52ceefebf2ead44eeda19a70912f157e0b44de3015708ba77c38101ac171"
    sha256 cellar: :any_skip_relocation, sonoma:         "e5ac2630bdde2ca6b932d4f778cd2694ef4f3763313f2481dc5c9c1ec6cff8d8"
    sha256 cellar: :any_skip_relocation, ventura:        "1fe25a83908b7c7ec9df34334a08d45686148c75520b2e593ecd5dacf0873ee6"
    sha256 cellar: :any_skip_relocation, monterey:       "1a6573d3a8500fe302e07ccbc3321d081ac88c63e42b57da429c041ae696500c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4ba31057cd0110c99fff217ce1b2b91d811390f4befbc3d0085221063a645e2b"
  end

  depends_on "go" => :build
  depends_on "docker" => :test

  def install
    ldflags = %W[
      -s -w
      -X github.com/dagger/dagger/engine.Version=v#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/dagger"

    generate_completions_from_executable(bin/"dagger", "completion")
  end

  test do
    ENV["DOCKER_HOST"] = "unix://#{testpath}/invalid.sock"

    assert_match "dagger v#{version}", shell_output("#{bin}/dagger version")

    output = shell_output("#{bin}/dagger query brewtest 2>&1", 1)
    assert_match "Cannot connect to the Docker daemon", output
  end
end
