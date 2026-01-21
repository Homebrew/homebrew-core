class Kiota < Formula
  desc "OpenAPI based HTTP Client code generator"
  homepage "https://aka.ms/kiota/docs"
  # Try upgrade to latest `dotnet` on next release
  url "https://github.com/microsoft/kiota/archive/refs/tags/v1.29.0.tar.gz"
  sha256 "8d75ae103efc94edc0615b1a7427ce6ef970fde389f3f4de5722eec97bcb4860"
  license "MIT"
  head "https://github.com/microsoft/kiota.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3ca572635df3058ea0bbb1cdb82421564caac65be8c8b1e61cc854e1b6338943"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a9c3b9ca9829ab90cc7b8597d8b340d9dcb1aecb27770250ec0d971da9eb505f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "68c6c9518430f0f768efeb287f540888ad7bbaa68cb92b9a1f646d768ded09a2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "171b247625f3c1bded7586c9837fff00d2439d52d61fd0f83a04dfd53916c30f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4f916084cae0e42d83e4db30186631bb3572f1a6f35e314efff6ab48180306b2"
  end

  depends_on "dotnet@9"

  def install
    dotnet = Formula["dotnet@9"]

    args = %W[
      --configuration Release
      --framework net#{dotnet.version.major_minor}
      --output #{libexec}
      --no-self-contained
      --use-current-runtime
      -p:TargetFramework=net#{dotnet.version.major_minor}
      -p:PublishSingleFile=true
    ]
    args << "-p:Version=#{version}" if build.stable?

    system "dotnet", "publish", "src/kiota/kiota.csproj", *args
    (bin/"kiota").write_env_script libexec/"kiota", DOTNET_ROOT: dotnet.opt_libexec
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kiota --version")

    info_output = shell_output("#{bin}/kiota info")
    assert_match "Go          Stable", info_output
    assert_match "Python      Stable", info_output

    search_output = shell_output("#{bin}/kiota search github")
    assert_match "apisguru::github.com                            GitHub v3 REST API", search_output
  end
end
