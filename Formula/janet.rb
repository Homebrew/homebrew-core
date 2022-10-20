class Janet < Formula
  desc "Dynamic language and bytecode vm"
  homepage "https://janet-lang.org"
  url "https://github.com/janet-lang/janet/archive/v1.25.0.tar.gz"
  sha256 "5bf9b680adbc5511835aec3787117df37032eef796e1664edbbcfd540b6acaf3"
  license "MIT"
  head "https://github.com/janet-lang/janet.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "89007ab0f0ca96531e52e210b2900843c370eb3dbd3110ca19efaf94d823f760"
    sha256 cellar: :any,                 arm64_big_sur:  "0ab00aeaf12c674ce1f5aa41b59dc514f5a5bde69166f4c9b83536c2feb39319"
    sha256 cellar: :any,                 monterey:       "376bb291e3348ca38ad3fb53899f1562fc6bd3255004a4db678ddd93c1ce760e"
    sha256 cellar: :any,                 big_sur:        "531d9f01dae16374e5dd39025838462c4ca907f29f0735039e0c637c57c24ab5"
    sha256 cellar: :any,                 catalina:       "60666f171882fe5e83b941d9baac201f94214fc8123e7c931c0f0db10070f37a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5fd58aa8996cc9d93bf7d1f17e1f47db090d59746ddf596ae53e3c91a1669773"
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
