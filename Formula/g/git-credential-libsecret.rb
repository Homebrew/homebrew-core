class GitCredentialLibsecret < Formula
  desc "Git helper for accessing credentials via libsecret"
  homepage "https://git-scm.com"
  url "https://mirrors.edge.kernel.org/pub/software/scm/git/git-2.43.2.tar.xz"
  sha256 "f612c1abc63557d50ad3849863fc9109670139fc9901e574460ec76e0511adb9"
  license "GPL-2.0-or-later"
  head "https://github.com/git/git.git", branch: "master"

  livecheck do
    formula "git"
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "1bc3c1f41f7cb553e37cd2e519276006035eb3da7d5e32e08ae393b4e6859827"
    sha256 cellar: :any,                 arm64_ventura:  "d06828110895873dd94577a15ebe21e43604b0a183c455b00c145f9fcdf36ca9"
    sha256 cellar: :any,                 arm64_monterey: "78c243b1c3286cee0da6d45e30b13cd8d2535a874d1021bde7bb722841e1b8f0"
    sha256 cellar: :any,                 sonoma:         "eb2a48441bd79eeb7d1ca231e7270467b9cc7c84762fe950f6314fbb61dde893"
    sha256 cellar: :any,                 ventura:        "e818e909857b2d3cde638331c034889ae44b1395a05d43aea4b6826331cf5bc9"
    sha256 cellar: :any,                 monterey:       "7341f7ae58248bcd3f453ee606cbf0f7e2cd13212e0a22254efdfc96ce073157"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "26e0936f646bd955073eef857925dea9361f19cdaffa2cb61c189c283ccd5d22"
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
