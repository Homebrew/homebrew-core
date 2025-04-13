class Facad < Formula
  desc "Modern, colorful directory listing tool for the command-line"
  homepage "https://github.com/yellow-footed-honeyguide/facad"
  url "https://github.com/yellow-footed-honeyguide/facad/archive/refs/tags/v2.20.9.tar.gz"
  sha256 "9ddf10abeb37694c364d169f2016f93fd9c85e3ef84cd3f20baaa571cc7a716e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9f254f619ffbaaee9f634eb1e39acce8328a1ed49b99add1e97c75c12885c906"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "23b0f0315fea0579a0b4a44f6b0d95416e75e8547a34c287b65c5ae979596f0b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d601aa8296bba837e4c734ca59b4babe599438a7a31476f71ce1a0de1b57dcf0"
    sha256 cellar: :any_skip_relocation, sonoma:        "ebbe6cf1e39dda7fb25f5eef9f29e80b675f96dcf62102507a06ce9d10d4bbf4"
    sha256 cellar: :any_skip_relocation, ventura:       "0de0e430aa3c0345fae2591c7892a2b6c8924ee2ebda42f5b33f66b6ebddeccc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9a20140fc6550154247ecacf7fc17201a7863673324a3ffe14a1a18a431d5053"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8f5acf8fc3823610c1d6c293b38004f5934eee765174942f59f23e86e9becf3f"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build

  def install
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    assert_match "facad version #{version}", shell_output("#{bin}/facad --version")

    Dir.mkdir("foobar")
    assert_match "📁 foobar", shell_output(bin/"facad")
  end
end
