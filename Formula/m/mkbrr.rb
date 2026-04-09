class Mkbrr < Formula
  desc "Is a tool to create, modify and inspect torrent files. Fast"
  homepage "https://mkbrr.com/introduction"
  url "https://github.com/autobrr/mkbrr/archive/refs/tags/v1.22.0.tar.gz"
  sha256 "69e6c10e8e507cfc4881d79158bab652fecc3131d2367ea4a6cb1073dda6e5ec"
  license "GPL-2.0-or-later"
  head "https://github.com/autobrr/mkbrr.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cf679a5c80a2372e39ebe4016da30ed00f59e5faccd66c55ebc9b755f86bbd15"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cf679a5c80a2372e39ebe4016da30ed00f59e5faccd66c55ebc9b755f86bbd15"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cf679a5c80a2372e39ebe4016da30ed00f59e5faccd66c55ebc9b755f86bbd15"
    sha256 cellar: :any_skip_relocation, sonoma:        "14594b364be9d7e83e97e93b1aa56eec7b4f5d77b0f1090ff6626089743324be"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0294a78756de18d545d526278d8b878236127e19fbe869ae479fa9ebada0722f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "35a1aa8a343ce1d86019bb6d5b73b86203feeaf223f4280aef7cf52fa10d68a0"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version} -X main.buildTime=#{time.iso8601}")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mkbrr version")

    (testpath/"hello.txt").write "Hello, World!"
    system bin/"mkbrr", "create", (testpath/"hello.txt"), "-o", (testpath/"hello.torrent")

    assert_path_exists testpath/"hello.torrent", "Failed to create torrent file"
  end
end
