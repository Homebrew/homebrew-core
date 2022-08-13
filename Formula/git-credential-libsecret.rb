class GitCredentialLibsecret < Formula
  desc "Git helper for accessing credentials via libsecret"
  homepage "https://git-scm.com"
  url "https://mirrors.edge.kernel.org/pub/software/scm/git/git-2.37.2.tar.xz"
  sha256 "1c3d9c821c4538e7a6dac30a4af8bd8dcfe4f651f95474c526b52f83406db003"
  license "GPL-2.0-or-later"
  head "https://github.com/git/git.git", branch: "master"

  livecheck do
    formula "git"
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "f751a64e600e7cad741a1cbd2ea6a376134fee6d2b3fde763fa8b26124282474"
    sha256 cellar: :any,                 arm64_big_sur:  "e41d342bc92b888994c618aa600b3c2937115df9e9a230ebbc0dcd5399a47cb2"
    sha256 cellar: :any,                 monterey:       "311afdc0bf085041b16562865be82431a621bd5b0cfdb83ddb1e350a919533d3"
    sha256 cellar: :any,                 big_sur:        "7cadab4f70b6e1734025bdb650eee4381039dff6267521dc28b1fcad4a63b414"
    sha256 cellar: :any,                 catalina:       "f207c9f45ddeae9df28fa11184ad68944cb9fdf2aa25ce052b61487e18f51386"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "325bdd60161df62231ab6c16db19d948aabf05903fc45280f27fcbfd6b744444"
  end

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "libsecret"

  def install
    cd "contrib/credential/libsecret" do
      system "make"
      bin.install "git-credential-libsecret"
    end
  end

  test do
    input = <<~EOS
      protocol=https
      username=Homebrew
      password=123
    EOS
    output = <<~EOS
      username=Homebrew
      password=123
    EOS
    assert_equal output, pipe_output("#{bin}/git-credential-libsecret get", input, 1)
  end
end
