class Circumflex < Formula
  desc "Hacker News in your terminal"
  homepage "https://github.com/bensadeh/circumflex"
  url "https://github.com/bensadeh/circumflex/archive/refs/tags/4.0.tar.gz"
  sha256 "48799d929afb0b4d0b2bca57ce7919eebd5ff11227f49fd851adf20a1689113a"
  license "MIT"
  head "https://github.com/bensadeh/circumflex.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f221aab5645f12b7d8187a21881906aabfdaa7e11c13e6facd5baea0c804b889"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f221aab5645f12b7d8187a21881906aabfdaa7e11c13e6facd5baea0c804b889"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f221aab5645f12b7d8187a21881906aabfdaa7e11c13e6facd5baea0c804b889"
    sha256 cellar: :any_skip_relocation, sonoma:        "98082abc7cbc19c8a3de2069320459d7ca20c9004fb29ad3f986d02c3ff450ce"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "47da3ca485277ef48e64a67b4cdd45e657e2d44f4b84943a39b9f07027ed7d3f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "78f6ce73a62d0763a860bd1530dd8e590e6b2405892444fc338278711fd47891"
  end

  depends_on "go" => :build
  depends_on "less"

  def install
    system "go", "build", *std_go_args(output: bin/"clx", ldflags: "-s -w"), "./cmd/clx"
    man1.install "share/man/clx.1"
  end

  test do
    ENV["XDG_CONFIG_HOME"] = testpath/".config"
    config_home = if OS.mac?
      testpath/"Library/Application Support"
    else
      testpath/".config"
    end

    assert_match "Item added to favorites", shell_output("#{bin}/clx add 1")
    assert_path_exists config_home/"circumflex/favorites.json"
  end
end
