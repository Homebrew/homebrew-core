class Ktor < Formula
  desc "Generates Ktor projects through the command-line interface"
  homepage "https://github.com/ktorio/ktor-cli"
  url "https://github.com/ktorio/ktor-cli/archive/refs/tags/0.2.1.tar.gz"
  sha256 "63a98fe44f912c9305e513d7c0428e06afdeb0f35c2088b1d500c9c9235f5226"
  license "Apache-2.0"
  head "https://github.com/ktorio/ktor-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "da21184d7653719644bd43e485f9a9fe5209bbd5760ee408123339fcb7d31235"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "da21184d7653719644bd43e485f9a9fe5209bbd5760ee408123339fcb7d31235"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "da21184d7653719644bd43e485f9a9fe5209bbd5760ee408123339fcb7d31235"
    sha256 cellar: :any_skip_relocation, sonoma:        "f2db82b992dcc990a985a350ec48691e463d6aceec3f92da717e8b93a1829290"
    sha256 cellar: :any_skip_relocation, ventura:       "f2db82b992dcc990a985a350ec48691e463d6aceec3f92da717e8b93a1829290"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e4dbabc68d684985930c294bdcc47ab59007dd4f7570191eaf17f2d879699ca7"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = "-X main.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "github.com/ktorio/ktor-cli/cmd/ktor"
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
