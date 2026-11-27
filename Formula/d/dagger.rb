class Dagger < Formula
  desc "Portable devkit for CI/CD pipelines"
  homepage "https://dagger.io"
  url "https://github.com/dagger/dagger/archive/refs/tags/v0.21.12.tar.gz"
  sha256 "4aaca8b6f4f31388b035ca9d2543a4fbc12d79fd7a8723efa3b533f1522d7530"
  license "Apache-2.0"
  head "https://github.com/dagger/dagger.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    manifest_sha256 "4f64c30d0ee94e6696924bf153415dd26cfd697fc626364f3ec0084f3122e809"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c8fe519acf057c5affac4953fde422658c584b91122c8a700388fe996c26648f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c8fe519acf057c5affac4953fde422658c584b91122c8a700388fe996c26648f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c8fe519acf057c5affac4953fde422658c584b91122c8a700388fe996c26648f"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "12143c7cc652f011feb3a47cb97488d57aff6c48711432bb81f45727c0a926d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "006607a6066a56a9aceb33e7df376f13476fbbe6168e710e10c282a44fb39706"
  end

  depends_on "go" => :build
  depends_on "docker" => :test

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"
    ldflags = %W[
      -X github.com/dagger/dagger/engine.Version=v#{version}
      -X github.com/dagger/dagger/engine.Tag=v#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/dagger"

    generate_completions_from_executable(bin/"dagger", shell_parameter_format: :cobra)
  end

  test do
    ENV["DOCKER_HOST"] = "unix://#{testpath}/invalid.sock"

    assert_match "dagger v#{version}", shell_output("#{bin}/dagger version")

    output = shell_output("#{bin}/dagger query brewtest 2>&1", 1)
    assert_match "failed to connect to the docker API", output
  end
end
