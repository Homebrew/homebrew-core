class Jid < Formula
  desc "Json incremental digger"
  homepage "https://github.com/simeji/jid"
  url "https://github.com/simeji/jid/archive/refs/tags/v1.1.2.tar.gz"
  sha256 "b86b8026e8aa216f31d31d8b9f6548be0533c4b20d555c65066db405075af081"
  license "MIT"
  head "https://github.com/simeji/jid.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "269ee721dfa60af977c18d9cc3af7d4968a08ed66cc658b6aeeed2d93e069435"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "269ee721dfa60af977c18d9cc3af7d4968a08ed66cc658b6aeeed2d93e069435"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "269ee721dfa60af977c18d9cc3af7d4968a08ed66cc658b6aeeed2d93e069435"
    sha256 cellar: :any_skip_relocation, sonoma:        "32759050183e23d9a98ff3bacc511d4a5105c11f32d6784840a6abd243db95f0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8c31c920d74115f9134182465c159f8e89461e5fd15089e5e008f24edb65ddad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ed80826920e70cc2b6c4a40bfc3b982e2c289ad90dc62a1dfcd8db317dabc7e7"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "cmd/jid/jid.go"
  end

  test do
    assert_match "jid version v#{version}", shell_output("#{bin}/jid --version")
  end
end
