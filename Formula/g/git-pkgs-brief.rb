class GitPkgsBrief < Formula
  desc "Tool that detects and reports a project's toolchain, configuration, and more"
  homepage "https://github.com/git-pkgs/brief"
  url "https://github.com/git-pkgs/brief/archive/refs/tags/v0.13.0.tar.gz"
  sha256 "15186cde57401e7886ec10629707aaba01d465b05f02a6d27fc05d9a0703ff11"
  license "MIT"
  head "https://github.com/git-pkgs/brief.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "240f01ced079efdf7707f3cf1c322ac78c1de095889ae802ed058f029c3a991c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "240f01ced079efdf7707f3cf1c322ac78c1de095889ae802ed058f029c3a991c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "240f01ced079efdf7707f3cf1c322ac78c1de095889ae802ed058f029c3a991c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d9be209f730f2085288e29b713c698dd8e3698504ed227b459c7f709f0ed8f85"
    sha256 cellar: :any,                 x86_64_linux:  "a76c8e005cc7fdbaa99dcb21d9704f81e7370e12728154dd269e3368f02c38df"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -X github.com/git-pkgs/brief.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"brief"), "./cmd/brief"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/brief -version")

    output = shell_output("#{bin}/brief https://github.com/Homebrew/brew")
    assert_match "license_type\": \"BSD-2-Clause\"", output
  end
end
