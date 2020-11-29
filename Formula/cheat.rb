class Cheat < Formula
  desc "Create and view interactive cheat sheets for *nix commands"
  homepage "https://github.com/cheat/cheat"
  url "https://github.com/cheat/cheat/archive/4.2.0.tar.gz"
  sha256 "23c3c30fe1ad63916718eef534dcef22c0ae607695f74860180304c5cde3ea49"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "d699a1d48fe05098f3f85824aded41a1627a0a7cd7931dc3aaf231e9e22159f8" => :big_sur
    sha256 "388447437190028ecd75df89cd5eb14c73a0a0fd9a8892c249293f44f037d2a7" => :catalina
    sha256 "d9464021001b8f486b0465fb7ae89f77c9f1d8415b2551887a23970584f36356" => :mojave
  end

  depends_on "go" => :build

  conflicts_with "bash-snippets", because: "both install a `cheat` executable"

  def install
    system "go", "build", "-mod", "vendor", "-o", bin/"cheat", "./cmd/cheat"

    bash_completion.install "scripts/cheat.bash"
    fish_completion.install "scripts/cheat.fish"
    zsh_completion.install "scripts/cheat.zsh"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cheat --version")

    output = shell_output("#{bin}/cheat --init 2>&1")
    assert_match "editor: vim", output
  end
end
