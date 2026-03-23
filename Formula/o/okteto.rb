class Okteto < Formula
  desc "Build better apps by developing and testing code directly in Kubernetes"
  homepage "https://okteto.com"
  url "https://github.com/okteto/okteto/archive/refs/tags/3.17.1.tar.gz"
  sha256 "0f855c95349dff8de053c7085f4821834ac31257ad55c05068ba758fbb13de5b"
  license "Apache-2.0"
  head "https://github.com/okteto/okteto.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "63f1c31b604e89303324098fb88e7a1340d2ae10ba397cb4b2a3acb93fd63bff"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cde63bb9641cbec0d73c06cb8afe746fe58c0776ef3fba037a8fd33a997909a4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9c901122d254fd116730bd37b7d1ec87f7181d605a14dbda08e1989036d6e170"
    sha256 cellar: :any_skip_relocation, sonoma:        "47452824c097d129bb3659ca5cefe0f7aba87d85675dd60edc37b6c30b271a62"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "44f9af056d9d3ed8f15fe4083bc2f6de55211df67abf056862cdb1ad643a20a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3f0a68335d5a197b2678f285ffd0460d885a21b2b4b3cad6ccddde77aaa904f5"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/okteto/okteto/pkg/config.VersionString=#{version}"
    tags = "osusergo netgo static_build"
    system "go", "build", *std_go_args(ldflags:, tags:)

    generate_completions_from_executable(bin/"okteto", shell_parameter_format: :cobra)
  end

  test do
    assert_match "okteto version #{version}", shell_output("#{bin}/okteto version")

    assert_match "Your context is not set", shell_output("#{bin}/okteto context list 2>&1", 1)
  end
end
