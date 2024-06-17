class Helix < Formula
  desc "Post-modern modal text editor"
  homepage "https://helix-editor.com"
  url "https://github.com/helix-editor/helix/releases/download/24.03/helix-24.03-source.tar.xz"
  sha256 "c59a5988f066c2ab90132e03a0e6b35b3dd89f48d3d78bf0ec81bd7d88c7677e"
  license "MPL-2.0"
  head "https://github.com/helix-editor/helix.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "87d01b554ff3ce3414c464700f2315cf5657adba826eaf0f85440937c50344ad"
    sha256 cellar: :any,                 arm64_ventura:  "9cd09bb8efce4564456143b3252a8d00e70fba77c46696c17fa00f961e17aaa4"
    sha256 cellar: :any,                 arm64_monterey: "9e33dd3b8c85f86500a53ce83a6c57c4202855eaf8fb10a628f621f5d003961d"
    sha256 cellar: :any,                 sonoma:         "cbacfb41908b359e203f0539eaaeda6a8665b1a5626a81f2a383b2e61b98060d"
    sha256 cellar: :any,                 ventura:        "79b5c7d19a6183b73f266f1237556b735f546ebb63f8b6e19788455928f06da2"
    sha256 cellar: :any,                 monterey:       "b8597dec017c06b4f5a341c1cd264fb42f87c2954b3dfaea155d8b22dd484680"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "58bd7e388a436e9ce1a8cbe74fcf16b2ce7c8012fd825641c9c371ca3cefa64e"
  end

  depends_on "rust" => :build

  fails_with gcc: "5" # For C++17

  def install
    ENV["HELIX_DEFAULT_RUNTIME"] = libexec/"runtime"
    system "cargo", "install", "-vv", *std_cargo_args(path: "helix-term")
    rm_r "runtime/grammars/sources/"
    libexec.install "runtime"

    bash_completion.install "contrib/completion/hx.bash" => "hx"
    fish_completion.install "contrib/completion/hx.fish"
    zsh_completion.install "contrib/completion/hx.zsh" => "_hx"
  end

  test do
    assert_match "post-modern text editor", shell_output("#{bin}/hx --help")
    assert_match "✓", shell_output("#{bin}/hx --health")
  end
end
