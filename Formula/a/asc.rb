class Asc < Formula
  desc "Fast, lightweight CLI for App Store Connect"
  homepage "https://asccli.sh"
  url "https://github.com/rorkai/App-Store-Connect-CLI/archive/refs/tags/4.3.0.tar.gz"
  sha256 "955d516e06c6e9cda40b2f781fd2b595409eb5e7b0966184795f75c0e818d162"
  license "MIT"
  head "https://github.com/rorkai/App-Store-Connect-CLI.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a7ac23e78f3394942af2d21cce7ac51844dfef85f44834e8622ae14507cd903e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9e5489aa3c6f4930d92939181bdd6375de0f4a02942c455665e3c61f7a2c1cba"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b1032a23bf3ffe5ef5accdf774222906cf1b7a7c4876f7d6a79857b40820fb8d"
    sha256 cellar: :any_skip_relocation, sonoma:        "e625e3a00a6aea0867ae5951cec7b2f2d97b6a959fdfa538d389d0f1780f4a64"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "72ff7e6fdca68494b0f6201acd0df9ca6b7620d9344769d881463f639451345a"
    sha256 cellar: :any,                 x86_64_linux:  "55dddaa5fe3f2f309fddbbdb0d4acff15571d02c984336c87daff5abcf98bcb6"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"asc", "completion", "--shell")
  end

  test do
    system bin/"asc", "init", "--path", testpath/"ASC.md", "--link=false"
    assert_path_exists testpath/"ASC.md"
    assert_match "asc cli reference", (testpath/"ASC.md").read
    assert_match version.to_s, shell_output("#{bin}/asc version")
  end
end
