class Matterbridge < Formula
  desc "Protocol bridge for multiple chat platforms"
  homepage "https://github.com/42wim/matterbridge"
  url "https://github.com/42wim/matterbridge/archive/v1.24.1.tar.gz"
  sha256 "ee2177f458a29dd8b4547cd6268fb8ac7e2ce2b551475427eca1205d67c236f4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8a1dc605ef22d7b5bd92536b4e31322b40016a6ffbc84840ebe0e0904bc1f850"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "06b43e635594d8f047b3d42b18cc56a7b68e1aa00fc69e057a4386e66c24b9b3"
    sha256 cellar: :any_skip_relocation, monterey:       "9191ba95abee3c87c76a15372694aad7daa97d29fcbad693d818835281509637"
    sha256 cellar: :any_skip_relocation, big_sur:        "588954e17bb83b13befc6effd3f4538f6b28704f50042e4217310c6e6fa74f67"
    sha256 cellar: :any_skip_relocation, catalina:       "023d20e5a8d51e1ca2e57fc6fa6fea56eb658e29a6dc94d39ca129ace23e5cb1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f835ac8526405d0c152b132b344bb126daf3e0665f2679a6bc76dedc57e42619"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    touch testpath/"test.toml"
    assert_match "no [[gateway]] configured", shell_output("#{bin}/matterbridge -conf test.toml 2>&1", 1)
  end
end
