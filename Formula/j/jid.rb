class Jid < Formula
  desc "Json incremental digger"
  homepage "https://github.com/simeji/jid"
  url "https://github.com/simeji/jid/archive/refs/tags/v1.1.3.tar.gz"
  sha256 "5d1092316e13eb3029a76ffd749cf1ad8642511fe3762f00635feea32d24b7d1"
  license "MIT"
  head "https://github.com/simeji/jid.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1dd50a3f952b19e719570406b5e3409192fdf86865cade2402fad1771cd27861"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1dd50a3f952b19e719570406b5e3409192fdf86865cade2402fad1771cd27861"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1dd50a3f952b19e719570406b5e3409192fdf86865cade2402fad1771cd27861"
    sha256 cellar: :any_skip_relocation, sonoma:        "fb4cb5d02296c9c3ad2e8c4a2d8716793778e989ac817eb3b21415f99bcffd77"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0250efd5f6ccf4edc28cb24d5aa2229d297073d4bba7613c9235362dcfb66ffa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "494d9cb13f8ffee317c868cf47cbfc2061cfb3f2b0cf58f7676cacc97d0e698a"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "cmd/jid/jid.go"
  end

  test do
    assert_match "jid version v#{version}", shell_output("#{bin}/jid --version")
  end
end
