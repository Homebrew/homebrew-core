class GitCredentialLibsecret < Formula
  desc "Git helper for accessing credentials via libsecret"
  homepage "https://git-scm.com"
  url "https://mirrors.edge.kernel.org/pub/software/scm/git/git-2.45.2.tar.xz"
  sha256 "51bfe87eb1c02fed1484051875365eeab229831d30d0cec5d89a14f9e40e9adb"
  license "GPL-2.0-or-later"
  head "https://github.com/git/git.git", branch: "master"

  livecheck do
    formula "git"
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "73a0f97d58303b2cfff48a000bbc8c5022e66093ef46c4baa4377fb1b0b883d5"
    sha256 cellar: :any,                 arm64_ventura:  "815f9e83f28060b46afc9737b47d3c5ad4b50a18b80d340df13a6f1ab0081d11"
    sha256 cellar: :any,                 arm64_monterey: "8e6c08d54c7cccd1e7629283bfcc8eafe7f1231cee5d473e681dc65d0d0087e3"
    sha256 cellar: :any,                 sonoma:         "906c684ecae7e3ccc6f1bfef04c7632c05156760f97819c8f027e75570e22600"
    sha256 cellar: :any,                 ventura:        "2c47bcffe0768c89609cb0f1a7c174d6c9d94fa9ad6e1c70f45673284537f893"
    sha256 cellar: :any,                 monterey:       "14aaa7c66831bc8d78bd7ece88a5b475325f56d0e159e95718a6975593f4e0d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d8f001c98f053148a1e6b7f9b49d8881c0a6322e3f40ca3ad9818cb45d1816ea"
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
