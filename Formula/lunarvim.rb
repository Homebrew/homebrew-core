class Lunarvim < Formula
  desc "IDE layer for Neovim. Completely free and community driven"
  homepage "https://www.lunarvim.org"
  url "https://github.com/LunarVim/LunarVim-mono/archive/refs/tags/stable.tar.gz"
  version "1.3.0"
  sha256 "4b63e968655d9a71ff32fdca653a56bd560555c1780d704669df578048b5f808"
  license "GPL-3.0-or-later"

  head do
    url "https://github.com/LunarVim/LunarVim-mono/archive/refs/tags/master.tar.gz"
    sha256 "b1a5e6474ea3fad3ac41866c7616a63f4fe649b5f68979a6a7a5fa8066016128"
  end

  depends_on "cmake" => :build
  depends_on "fd"
  depends_on "neovim"
  depends_on "node"
  depends_on "python@3.11"
  depends_on "ripgrep"
  depends_on "tree-sitter"

  def install
    system "cmake", "-B", "build", *std_cmake_args

    cd "build" do
      system "cpack || :"
    end

    prefix.install Dir["build/_CPack_Packages/Darwin/TGZ/lvim-macos/*"]
  end

  test do
    assert_equal true, shell_output("#{bin}/lvim -v").start_with?("NVIM")
    assert_equal "lmao", pipe_output("#{bin}/lvim -Es +%print", "lmao\n").strip
  end
end
