class Mockery < Formula
  desc "Mock code autogenerator for Golang"
  homepage "https://github.com/vektra/mockery"
  url "https://github.com/vektra/mockery/archive/refs/tags/v2.43.0.tar.gz"
  sha256 "b92e7e56776c42f6848d6bcf32b104d80575004a4290cae8170676e8f20106c6"
  license "BSD-3-Clause"
  head "https://github.com/vektra/mockery.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ca104bce9566fe9b5d56d26f273ceb303a145daea7924a7c93c9364810c4cf94"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "38f97cee66d81fb546421dd59eda612b454afd88b153db7ffd5581fe37228199"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3daef3a114ced670d6e771ea95994e7cab8291be68781e26013176fa3f26f930"
    sha256 cellar: :any_skip_relocation, sonoma:         "163f52ad6d3965f54f36d42c2c066dd87027bdcea0532359b27a0a1c937351e4"
    sha256 cellar: :any_skip_relocation, ventura:        "194764d54b868da8901fc463c71c69a639468a8f2c4f86e91591c3c558d0700c"
    sha256 cellar: :any_skip_relocation, monterey:       "1ad41033931ef92248f86e02f63c208432aa500d198d9c5224ea3562a68e3b28"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e4a2afa4e95f7947d58a74f142a478250e0e15568e05ee6a4a7416f62177fb80"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/vektra/mockery/v2/pkg/logging.SemVer=v#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"mockery", "completion")
  end

  test do
    output = shell_output("#{bin}/mockery --keeptree 2>&1", 1)
    assert_match "Starting mockery dry-run=false version=v#{version}", output

    output = shell_output("#{bin}/mockery --all --dry-run 2>&1")
    assert_match "INF Starting mockery dry-run=true version=v#{version}", output
  end
end
