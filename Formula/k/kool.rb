class Kool < Formula
  desc "Web apps development with containers made easy"
  homepage "https://kool.dev"
  url "https://github.com/kool-dev/kool/archive/refs/tags/3.5.3.tar.gz"
  sha256 "c67d8fcc7c76d519b0cbb263f205d9eed15000eb065f226ba48110e8ec652f4a"
  license "MIT"
  head "https://github.com/kool-dev/kool.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0d60ac5f127a4462fa18f95855d70b981157e7b80aec63440995edf5f809008f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0d60ac5f127a4462fa18f95855d70b981157e7b80aec63440995edf5f809008f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0d60ac5f127a4462fa18f95855d70b981157e7b80aec63440995edf5f809008f"
    sha256 cellar: :any_skip_relocation, sonoma:        "afe91028208f535bc6ba507c45145857a57a32708618111203dea4fd84834803"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aac8749cd8b85d03451fca74d583c14b52bfeade204962b10ac3362bc2c3458b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9636f92c2aa2ecf29a069af8e19359f67d64d8dfe21555d951951386551d2c5e"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X kool-dev/kool/commands.version=#{version}")

    generate_completions_from_executable(bin/"kool", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kool --version")
    assert_match "docker doesn't seem to be installed", shell_output("#{bin}/kool status 2>&1", 1)
  end
end
