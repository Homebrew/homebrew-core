class GitCredentialLibsecret < Formula
  desc "Git helper for accessing credentials via libsecret"
  homepage "https://git-scm.com"
  url "https://mirrors.edge.kernel.org/pub/software/scm/git/git-2.39.2.tar.xz"
  sha256 "475f75f1373b2cd4e438706185175966d5c11f68c4db1e48c26257c43ddcf2d6"
  license "GPL-2.0-or-later"
  head "https://github.com/git/git.git", branch: "master"

  livecheck do
    formula "git"
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "f9faef6b5a3bc8200be95bc511466559d525d246a9cb5e01ca561c9c6a43a5ce"
    sha256 cellar: :any,                 arm64_monterey: "204574e8e515ea73712c74c06aeae236bacdcfc49a62f3757d58d5d55a0c434c"
    sha256 cellar: :any,                 arm64_big_sur:  "64a468d6b313924b59c466d0459c888337dd7348a22a62ff884a11fb0b2eea7b"
    sha256 cellar: :any,                 ventura:        "fec255c8760f3d03e6917c13ac739c7aeffd76999247d949e74e09e8ca50eaee"
    sha256 cellar: :any,                 monterey:       "8ccb37aebab406b6f293c6067e98af234dd32fb5570cb709e65b54827761b129"
    sha256 cellar: :any,                 big_sur:        "1ce7fe99aeb626923c672a94e18dcedf24b6578cc5a8fb8f6387227676ad3d11"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6ba1d7317b5c0312a44484e6e09e23a94fd7c907d1da636bda0fefaa3a528190"
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
