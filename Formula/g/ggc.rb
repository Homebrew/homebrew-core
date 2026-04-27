class Ggc < Formula
  desc "Modern Git CLI"
  homepage "https://github.com/bmf-san/ggc"
  url "https://github.com/bmf-san/ggc/archive/refs/tags/v8.4.0.tar.gz"
  sha256 "d319caab311aa70f577ddf23773284f2ad3f3b34685275a2b24ca887fef02f2e"
  license "MIT"
  head "https://github.com/bmf-san/ggc.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d83b5901669ea271580a59eaddc7453c829fdf9562fb9c4c25610b9c2d059068"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d83b5901669ea271580a59eaddc7453c829fdf9562fb9c4c25610b9c2d059068"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d83b5901669ea271580a59eaddc7453c829fdf9562fb9c4c25610b9c2d059068"
    sha256 cellar: :any_skip_relocation, sonoma:        "102bdbe16a42902943ab5e205962dce099a6a1d47805f90f5975428d545d95a1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3fa12bef2c82ad1f1cb48f100f8e426a4db549e46540c00c389739fc9ca79742"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a198a4d4a954b7200ee490f831d625ce07fd20b66077f483fb8eeff9f20969a0"
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
