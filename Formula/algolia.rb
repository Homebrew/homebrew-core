class Algolia < Formula
  desc "Official Algolia Command-line tool"
  homepage "https://github.com/algolia/cli"
  url "https://github.com/algolia/cli/archive/v1.2.1.tar.gz"
  sha256 "520c993a9a8f25655fa7298260fe01f0bd915fa355e07099198f23a39fb479ee"
  license "MIT"

  head "https://github.com/algolia/cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  depends_on "go" => :build

  def install
    with_env(
      "VERSION" => version,
    ) do
      system "make", "build"
    end
    bin.install "algolia"
    generate_completions_from_executable(bin/"algolia", "completion")
  end

  test do
    assert_match "algolia version #{version}", shell_output("#{bin}/algolia --version")
    assert_match "Manage your Algolia indices", shell_output("#{bin}/algolia indices 2>&1")
    assert_match "Manage your indices' objects", shell_output("#{bin}/algolia objects 2>&1")
  end
end
