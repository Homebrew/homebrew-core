class Mcfly < Formula
  desc "Fly through your shell history"
  homepage "https://github.com/cantino/mcfly"
  url "https://github.com/cantino/mcfly/archive/refs/tags/v0.9.4.tar.gz"
  sha256 "31cdd76bfab3b05b4873bc20f03eb022e5a5d68f6595bc6df5dd9fce4b519e53"
  license "MIT"
  head "https://github.com/cantino/mcfly.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "adb59f4c01dfe97f374aab237d28fb3206dc85daf3a85a0b425eb1aa6f1c8d29"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "37c37ed43e36e995c8ec71cb72dd4f3f4e2271fa46e9c666d9549322078fafc1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8e2584592bb53ae2eea44285f31e7bd39569838ebbcdc6962d1bfe6818122a89"
    sha256 cellar: :any_skip_relocation, sonoma:        "1f25c5093b996476e61ae0182bca0b73a8ff66dba729f2a95c5ac942d109018d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4cc5e2c97279ba22d4f2114e05668037a40ee42591d9beec496ee4b928bac539"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8485745197b6e8cdbdbff7c2ad76b15519c62501614fd0389a5d29c0a5d99b0c"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "mcfly_prompt_command", shell_output("#{bin}/mcfly init bash")
    assert_match version.to_s, shell_output("#{bin}/mcfly --version")
  end
end
