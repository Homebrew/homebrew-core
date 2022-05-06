class GitCredentialLibsecret < Formula
  desc "Git helper for accessing credentials via libsecret"
  homepage "https://git-scm.com"
  url "https://mirrors.edge.kernel.org/pub/software/scm/git/git-2.36.1.tar.xz"
  sha256 "405d4a0ff6e818d1f12b3e92e1ac060f612adcb454f6299f70583058cb508370"
  license "GPL-2.0-or-later"
  head "https://github.com/git/git.git", branch: "master"

  livecheck do
    formula "git"
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "54b27dc5092c3d0370e5c78fd14be4e5f12bccbd36e870307c265e1cf61a576f"
    sha256 cellar: :any,                 arm64_big_sur:  "e84ef40af0e27d987e1a475e02785f279d0c2eb3ea4df96f4ffa090f7c272a6d"
    sha256 cellar: :any,                 monterey:       "083102d92a43189d57fd3cac721744100459347330b225f488f5e5993ec1e01e"
    sha256 cellar: :any,                 big_sur:        "71e566c12c8ea3dd0247f6b95ed609dc2e34f518e9e881ccf955555a1c55174d"
    sha256 cellar: :any,                 catalina:       "f2dd8a5ca6a4914221fcca55d64c5d41e52f91fb1ebfc1335a4a76e72f821274"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "03891ddf3984e6b4ee28eeb99ef290c426e8fd55753041e8f039ffb0c29972a6"
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
