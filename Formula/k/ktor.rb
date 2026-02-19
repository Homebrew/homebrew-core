class Ktor < Formula
  desc "Generates Ktor projects through the command-line interface"
  homepage "https://github.com/ktorio/ktor-cli"
  url "https://github.com/ktorio/ktor-cli/archive/refs/tags/0.5.0.tar.gz"
  sha256 "6bc452b6aa7e4a911649f10359a0c00d0017e8ab3a3c70b0e1412c026794f6a3"
  license "Apache-2.0"
  head "https://github.com/ktorio/ktor-cli.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "80dcedda4ea9f655c16984014ca3b31d5602f7920d20af606d48fc13424bc81f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ae5827c1b6127ef87c86509969b51b57e264b3a86e2ff7f89f1ae2dd2d61fe7d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "320e97018245a83890d9d43f902bc9d3c15b052ce0168b0156d1046c26df271d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "67e92b3134de86c1f73851c12756d0b60b8d395d62eb599cc0688e2539d92ce4"
    sha256 cellar: :any_skip_relocation, sonoma:        "b348f62c90905932ac7a0758eddb06ba18f61415034790c0d1cfb867e3512d5e"
    sha256 cellar: :any_skip_relocation, ventura:       "40853271a7712e7914374bbe56cbf5eba3f14586b5568991a78bff8d46283643"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0e58b14f78b06fc59b575bbb1c624bba3ce15888a2c01073b358c31f47dc1920"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e3d5add07175e7adaab1079cd90d759fedd35ab162f57268c511a23d388164c1"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/ktor"
    generate_completions_from_executable(bin/"ktor", "completions")
  end

  test do
    assert_match "Ktor CLI version #{version}", shell_output("#{bin}/ktor --version")
    assert_match "Ktor CLI version #{version}", shell_output("#{bin}/ktor version")
    system bin/"ktor", "new", "project"
    assert_path_exists testpath/"project/build.gradle.kts"
    assert_path_exists testpath/"project/settings.gradle.kts"
    assert_path_exists testpath/"project/gradle.properties"
    assert_path_exists testpath/"project/src"
    assert_path_exists testpath/"project/gradle"
  end
end
