class Facad < Formula
  desc "Modern, colorful directory listing tool for the command-line"
  homepage "https://github.com/yellow-footed-honeyguide/facad"
  url "https://github.com/yellow-footed-honeyguide/facad/archive/refs/tags/v2.20.16.tar.gz"
  sha256 "4de8b7021efb0ec6f9bf71f0f70cb33e1cf52e945cc99e80760b80767dc380d7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b2d62171e0a66f415fbdace7168e5f04f1e262074b3c5b340ea145e139d321df"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fbb2b9b54e71b909a15edde995f0d338be9066e7e5f13692a9d020ca9aff694e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ebbb4be54e72be49c2780b3686195a73868fd2e53d43db912cba201b88eaa768"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ab0a95d9a26c50834dc5a836614d9c42377789880477a1c40e2632d325b3e44f"
    sha256 cellar: :any_skip_relocation, sonoma:        "d6f315744dfd974eb77df2e2e5d8d79648dde77f21e70f39d26849661fe709bb"
    sha256 cellar: :any_skip_relocation, ventura:       "aec4f6294fd7f106723203f8e26ffc3d12cf2eac6dcfd0d5a791fc353128871f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6dcb9d87a0c649731817a61e9bd637595f44f3a2026fe88dc3bc0e4d286907ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "708616d9bd5c34b25e5f86c55088bb99efbe5ab13220215b82fd151f3eccf14f"
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
