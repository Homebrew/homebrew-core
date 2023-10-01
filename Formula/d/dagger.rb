class Dagger < Formula
  desc "Portable devkit for CI/CD pipelines"
  homepage "https://dagger.io"
  url "https://github.com/dagger/dagger.git",
      tag:      "v0.8.7",
      revision: "60ffcd563b854e2731a23d130a131acdb1f3b521"
  license "Apache-2.0"
  head "https://github.com/dagger/dagger.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ddfcf9a10b12bc5052f8964dbd86b5ecf9dcc424b13237a77d0a234eb5210fd6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0e45fe40938f1a566a529c0788ea2b438c0e8f3114dcb034e0fcbe7a1d7f1dc6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ecde0d74339ea7bc6548d201bda44db8bf91bc6659bfa9c1f3e8ed3908c08def"
    sha256 cellar: :any_skip_relocation, ventura:        "055710db975b8917a49c9f21008a91724115bfcc037cf45e74bebeb210cd1a12"
    sha256 cellar: :any_skip_relocation, monterey:       "7ef60e270befa844e2967705847b6f311fda07655d18ea5312904f54a4a718df"
    sha256 cellar: :any_skip_relocation, big_sur:        "5c0b5cdf82a06ae567cc73ef71dc904b69e63741b6b09e6b78d2bf1c227f9c8c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "95d9a31efd232f6f6692b8cb6184392f29c313a6ed6fb032ea483a111db906a5"
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
