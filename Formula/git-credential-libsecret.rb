class GitCredentialLibsecret < Formula
  desc "Git helper for accessing credentials via libsecret"
  homepage "https://git-scm.com"
  url "https://mirrors.edge.kernel.org/pub/software/scm/git/git-2.40.0.tar.xz"
  sha256 "b17a598fbf58729ef13b577465eb93b2d484df1201518b708b5044ff623bf46d"
  license "GPL-2.0-or-later"
  head "https://github.com/git/git.git", branch: "master"

  livecheck do
    formula "git"
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "f90fde059b967920342661e71e0ed86a1b7b7e68c6c3d7ca5faf24d389677878"
    sha256 cellar: :any,                 arm64_monterey: "c30a4775f43c5eb69df27e635b5c257db3410e6cfa335f1de97250fdfd110cb5"
    sha256 cellar: :any,                 arm64_big_sur:  "7bac858dbeccb037381c0599be74df4eae8e21ffef741e8a4c4664eea8f6bfb0"
    sha256 cellar: :any,                 ventura:        "a11b1952cd67588168daed601730b74746c2dd1dc6ce3eba61c6bc8edf427a12"
    sha256 cellar: :any,                 monterey:       "741f2d015c37c368e240574b1f5a2c33936ff1e000ee8674b80be13a0553b21e"
    sha256 cellar: :any,                 big_sur:        "d366a9b5fe34aaddfd4f93a4d1a380567de6e38e1919bfe23f467609d258329b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f5f900e3b6b07fb1c6c56e90fc914c4a1e38b493c7db856e7d3124e2a4c0769a"
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
