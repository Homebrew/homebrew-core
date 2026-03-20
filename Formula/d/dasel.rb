class Dasel < Formula
  desc "JSON, YAML, TOML, XML, and CSV query and modification tool"
  homepage "https://github.com/TomWright/dasel"
  url "https://github.com/TomWright/dasel/archive/refs/tags/v3.4.0.tar.gz"
  sha256 "e8f758d08ac330e0a0e610bd9a6397341ed2d96700b47b175ec10411891ecd8c"
  license "MIT"
  head "https://github.com/TomWright/dasel.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8eeb058f763cd1b009dca8caccb32b335c65eff5d6dda4b7bb3cfbeff5087407"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8eeb058f763cd1b009dca8caccb32b335c65eff5d6dda4b7bb3cfbeff5087407"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8eeb058f763cd1b009dca8caccb32b335c65eff5d6dda4b7bb3cfbeff5087407"
    sha256 cellar: :any_skip_relocation, sonoma:        "54987695279117ff51da03e6d15623aa0c3a4a6262dd9485385eca7605989370"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2d0aed89d62012eaf0a684f5b72bdcfb2068f9125f6a8837dc47c8c1f714636f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "88cd2d358f5e2f93802a121a8b709326d369752a877f2c2649422aca09698000"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/tomwright/dasel/v#{version.major}/internal.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/dasel"
  end

  test do
    assert_equal "\"Tom\"", pipe_output("#{bin}/dasel -i json 'name'", '{"name": "Tom"}', 0).chomp
    assert_match version.to_s, shell_output("#{bin}/dasel version")
  end
end
