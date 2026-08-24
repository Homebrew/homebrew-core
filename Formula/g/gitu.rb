class Gitu < Formula
  desc "TUI Git client inspired by Magit"
  homepage "https://github.com/altsem/gitu"
  url "https://github.com/altsem/gitu/archive/refs/tags/v0.43.0.tar.gz"
  sha256 "4cc89732b2fa4fee07b2db5ce4cf325577fd195995e70e11c86b9bc1a6a2e114"
  license "MIT"
  head "https://github.com/altsem/gitu.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "82e399d7d9876840a2334309d55e904bec01dff74f5fd86a2bd7d30b7f7740f6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e3c8970d9abdba0a7e100f6ae45ed5325b6ec429bd0fcc75782b1eb78523b587"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0c82df7e66a65bc359d66c22f11751bd006ddf555691d1e46619a0fcecec8374"
    sha256 cellar: :any_skip_relocation, sonoma:        "05cf09761faa012a9cbde46d0b435893761a83035fa79d6992b8618f28719647"
    sha256 cellar: :any,                 arm64_linux:   "cae4fe3c6154c7cf0239084ac09891f2bcb047a89dee11b0857abd4cede817fe"
    sha256 cellar: :any,                 x86_64_linux:  "5be7cb1d077249375566c0efdd4bbb9768b5a169958956cef223aaa8598409c3"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gitu --version")

    assert_match "could not find repository at '.'", shell_output("#{bin}/gitu 2>&1", 1)
  end
end
