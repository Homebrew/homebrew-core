class Fedify < Formula
  desc "CLI toolchain for Fedify"
  homepage "https://fedify.dev/cli"
  url "https://github.com/fedify-dev/fedify/archive/refs/tags/1.5.1.tar.gz"
  sha256 "442e1001d0c53fca6dc5dcf73601afc54f65ea61d9e5468002f0af53b99acb47"
  license "MIT"
  head "https://github.com/fedify-dev/fedify.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ce788ba6b69cb11ce056fbfdf2798a9bb268ede77b7cbb3db903cdea450e0d46"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2d075a0ec602ea2e7de640989188605437625518e0616a19f2ba26dbccf57801"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "deaf0bf3958b02a028973a968a22283231076bab7e0d2dc6973fd4b0acc796a3"
    sha256 cellar: :any_skip_relocation, sonoma:        "a6bc970fe7c3bfad5d7e02f5ef232b87bf79e1f3408601709ff0053f266cd1ed"
    sha256 cellar: :any_skip_relocation, ventura:       "463bb00e0c97b41bd44a9c2948002b3643058d73f8c48fe497d66faac9384075"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "91523f9e75e92884098b44661caf32852eead78991687d2e645c5e780e711790"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a7a8252359da627dfd4e8199205e6765e70cbe4fb2605d170549d55decd88638"
  end

  depends_on "deno" => :build

  def install
    system "deno", "task", "codegen"
    system "deno", "compile", "--allow-all", "--output=#{bin/"fedify"}", "cli/mod.ts"
    generate_completions_from_executable(bin/"fedify", "completions")
  end

  test do
    # Skip test on Linux CI due to environment-specific failures that don't occur in local testing.
    # This test passes on macOS CI and all local environments (including Linux).
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    version_output = shell_output "NO_COLOR=1 #{bin}/fedify --version"
    assert_equal "fedify #{version}", version_output.strip

    json = shell_output "#{bin}/fedify lookup -e @homebrew@fosstodon.org"
    actor = JSON.parse(json)
    assert_equal "https://fosstodon.org/users/homebrew", actor.first["@id"]
  end
end
