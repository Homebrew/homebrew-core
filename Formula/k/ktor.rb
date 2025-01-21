class Ktor < Formula
  desc "Generates Ktor projects through the command-line interface"
  homepage "https://github.com/ktorio/ktor-cli"
  url "https://github.com/ktorio/ktor-cli/archive/refs/tags/0.4.0.tar.gz"
  sha256 "2974a54571d410150932fe75c31b272a8716b22005deb08589e66ce8b13e2337"
  license "Apache-2.0"
  head "https://github.com/ktorio/ktor-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ef29358929e39ab83589b1be6e677ec20dfb362f234502499ab548ed7f2ce1ee"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ef29358929e39ab83589b1be6e677ec20dfb362f234502499ab548ed7f2ce1ee"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ef29358929e39ab83589b1be6e677ec20dfb362f234502499ab548ed7f2ce1ee"
    sha256 cellar: :any_skip_relocation, sonoma:        "5a1c07b2b9402f89f51c7b40da8ea66d0080f42dbfcb278fe7240bb9051040e3"
    sha256 cellar: :any_skip_relocation, ventura:       "5a1c07b2b9402f89f51c7b40da8ea66d0080f42dbfcb278fe7240bb9051040e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f31416687eee921e9d7c12159ccc834b9e0693375096f904d68c67fe82ce7d74"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/ktor"
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
