class Algolia < Formula
  desc "Official Algolia Command-line tool"
  homepage "https://github.com/algolia/cli"
  url "https://github.com/algolia/cli/archive/v1.2.0.tar.gz"
  sha256 "dfac3191869753bf1af6000c32b2cc404a6e7947ee6820f5614d8f292269471c"
  license "MIT"

  head "https://github.com/algolia/cli.git", branch: "master"

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
