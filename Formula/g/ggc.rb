class Ggc < Formula
  desc "Modern Git CLI"
  homepage "https://github.com/bmf-san/ggc"
  url "https://github.com/bmf-san/ggc/archive/refs/tags/v7.0.5.tar.gz"
  sha256 "12c1c415178bb9313c424740dc61739920ba238d0b25f54b9ef984b775ee0b81"
  license "MIT"
  head "https://github.com/bmf-san/ggc.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "70cfa1fcdbdefcaf9d5685aa1e215642c800c03c1ab620158d743e23e46b880e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "70cfa1fcdbdefcaf9d5685aa1e215642c800c03c1ab620158d743e23e46b880e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "70cfa1fcdbdefcaf9d5685aa1e215642c800c03c1ab620158d743e23e46b880e"
    sha256 cellar: :any_skip_relocation, sonoma:        "0aeda1bb0ffaeb44b82b34ba794d18c559b4b39507cef7d4cef4b0db953b55b4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1c9be607c35a1d6f320350cdbc127ddb00cf04c59508db7bc0ff33cacfb79939"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2e6747e2a50bd024e9243e2dab1de58724d6b65dbdbfbaa672d59618bf3be9a8"
  end

  depends_on "go" => :build

  uses_from_macos "vim"

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ggc version")
    assert_equal "main", shell_output("#{bin}/ggc config get default.branch").chomp
  end
end
