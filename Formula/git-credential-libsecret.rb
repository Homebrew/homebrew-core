class GitCredentialLibsecret < Formula
  desc "Git helper for accessing credentials via libsecret"
  homepage "https://git-scm.com"
  url "https://mirrors.edge.kernel.org/pub/software/scm/git/git-2.36.0.tar.xz"
  sha256 "af5ebfc1658464f5d0d45a2bfd884c935fb607a10cc021d95bc80778861cc1d3"
  license "GPL-2.0-or-later"
  head "https://github.com/git/git.git", branch: "master"

  livecheck do
    formula "git"
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "d615ed968f76b949bd322bd7dfac03e72e05161f212d8806bbfe711a041ad545"
    sha256 cellar: :any,                 arm64_big_sur:  "875410a3bd47f82442eaeaaba98f83b5c240ab2b1f4e1267ac3769a3bdda6df8"
    sha256 cellar: :any,                 monterey:       "9a700a45e34af1b6392766c9713e792b5bc8b2c5cc05d668572cde16cc1710dc"
    sha256 cellar: :any,                 big_sur:        "84c9f0dac38a05ca8619864c798bd1151f605f9af2d4927999ae2948f40e9c90"
    sha256 cellar: :any,                 catalina:       "d36b3fe7c18579957dc446c86145e22fbd37aebfad0b505b4a40c96dd4a03544"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a5045619b7606dbb7d1ca74157b0d2dc32b8ef4a14ed2f307a8d80ed4f43d4e0"
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
