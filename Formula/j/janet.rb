class Janet < Formula
  desc "Dynamic language and bytecode vm"
  homepage "https://janet-lang.org"
  url "https://github.com/janet-lang/janet/archive/v1.30.0.tar.gz"
  sha256 "64a8a923f5c5065047c91cce9c27ed0a60899ad5810b2c6f590bc5e24a4e834b"
  license "MIT"
  head "https://github.com/janet-lang/janet.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "3e3d0eff453af14a7ad4ca3458b8c880b13aeecf2446811eb8e2fb14a045d0f8"
    sha256 cellar: :any,                 arm64_monterey: "c86ae02ac99c9569057d4753404f885ed6baebdb1140db6ab8762f79fb9dc915"
    sha256 cellar: :any,                 arm64_big_sur:  "f86f7e5cb0aa966e009e834fd6753fe1cc37ec1d91b326719e6ee93b675e215d"
    sha256 cellar: :any,                 ventura:        "4a55b330bf7eee1ad8193e651086c5a44f09ca7902c10ea76d0bf4d143566be5"
    sha256 cellar: :any,                 monterey:       "857f0aa9a60e3629a997ee7d56e21ee0f4267ac47750ffe840b325068d69be8b"
    sha256 cellar: :any,                 big_sur:        "f70a11045958567e165c4916e21848bc030ae247e17eccfd30d2c74ad56709d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0777c4eaaf9e45251934954259fbb4dfb16eaca4e909755ebce384dcf7684cf3"
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
