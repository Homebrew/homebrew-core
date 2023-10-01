class Janet < Formula
  desc "Dynamic language and bytecode vm"
  homepage "https://janet-lang.org"
  url "https://github.com/janet-lang/janet/archive/v1.31.0.tar.gz"
  sha256 "1f5064b97313b93f282e36584dfb7d491dd13d6ccf4f6550281232e77ccef780"
  license "MIT"
  head "https://github.com/janet-lang/janet.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "0b0ab17b6496c7cb26ad53dea43aab050eed1e2c1d12bd85477de6c88c9e8e76"
    sha256 cellar: :any,                 arm64_monterey: "c804e4fa2ebd094f5b42d42830f659f2c4c88fe870155d99df95c02c55f082c2"
    sha256 cellar: :any,                 arm64_big_sur:  "7ebef2db661fc1a91f49d8f98641603556dde41ef57159e811ca16b479bb72cb"
    sha256 cellar: :any,                 ventura:        "180e87e361a65d52f4ce416f031e9f53019592b83bcc2a0d1568dac74a9d3cf3"
    sha256 cellar: :any,                 monterey:       "69785c69b0edea20fffe24bc7dfe1d21e7bd43a625af4fb2b4daf6225051b2a2"
    sha256 cellar: :any,                 big_sur:        "dfdbb0e7df1e62538020878225188e704ded3b272d2d9a954b646d7d8c84da83"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f7953fdb26a6b267f648896dfa22ce10c56b688cfdf13319f08982554e9a2459"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build

  resource "jpm" do
    url "https://github.com/janet-lang/jpm/archive/refs/tags/v1.1.0.tar.gz"
    sha256 "337c40d9b8c087b920202287b375c2962447218e8e127ce3a5a12e6e47ac6f16"
  end

  def install
    system "meson", "setup", "build", *std_meson_args
    cd "build" do
      system "ninja"
      system "ninja", "install"
    end
    ENV["PREFIX"] = prefix
    resource("jpm").stage do
      system bin/"janet", "bootstrap.janet"
    end
  end

  test do
    assert_equal "12", shell_output("#{bin}/janet -e '(print (+ 5 7))'").strip
    assert_predicate HOMEBREW_PREFIX/"bin/jpm", :exist?, "jpm must exist"
    assert_predicate HOMEBREW_PREFIX/"bin/jpm", :executable?, "jpm must be executable"
    assert_match prefix.to_s, shell_output("#{bin}/jpm show-paths")
  end
end
