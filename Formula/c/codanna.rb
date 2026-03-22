class Codanna < Formula
  desc "Code intelligence system with semantic search"
  homepage "https://github.com/bartolli/codanna"
  url "https://github.com/bartolli/codanna/archive/refs/tags/v0.9.17.tar.gz"
  sha256 "d0f6965cd1168320bc595127def22c1973c04e8b7a5f5b85b0458197fcaef447"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "12376ddff72593344793b51179bcdc6eef01407b39afe5ed83c8fc11b8f6b066"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6642ae3565d8910d7e71b8c0cba69050883df027bb1aaa20449b22427ea945cd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f798fb92666012cff957c6de26bbeca00000314744d095b8931668ef1990bec5"
    sha256 cellar: :any_skip_relocation, sonoma:        "1bffeda0842ee7d1597d8cee1b2f7c45a154f3193a6aed05223210bf4bc5bb57"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f5fcfb78a58068103e5c00fe963c96ba06d1cece21a30a2e4686a9cc9420f6a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ab30d45901b22ded7d2d088d12ee76f5a7743453e38ffda3b56d628556fb4c04"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "cargo", "install", *std_cargo_args, "--all-features"
  end

  test do
    system bin/"codanna", "init"
    assert_path_exists testpath/".codanna"
  end
end
