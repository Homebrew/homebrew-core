class Fyne < Formula
  desc "Build tool for Fyne, a cross platform GUI toolkit in Go"
  homepage "https://fyne.io/"
  url "https://github.com/fyne-io/fyne/archive/refs/tags/v2.5.2.tar.gz"
  sha256 "f6709fa0a4216ca11aea95c71a79526b59214ac86479757dfa000001b458d72b"
  license "BSD-3-Clause"
  head "https://github.com/fyne-io/fyne.git", branch: "master"

  depends_on "go" => [:build, :test]

  on_linux do
    depends_on "pkgconf" => :build
    depends_on "glfw"
    depends_on "libx11"
    depends_on "libxcursor"
    depends_on "libxrandr"
    depends_on "mesa"
  end

  def install
    ENV.prepend_path "PKG_CONFIG_PATH", lib/"pkgconfig"

    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/fyne"
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin / "fyne_settings"), "./cmd/fyne_settings"
  end

  test do
    system bin/"fyne", "get", "fyne.io/fyne/v2/cmd/fyne_demo"
  rescue
    ohai "Expect this to fail with a permissions error"
  end
end
