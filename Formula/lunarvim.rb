class Lunarvim < Formula
  desc "IDE layer for Neovim. Completely free and community driven"
  homepage "https://www.lunarvim.org"
  url "https://github.com/LunarVim/LunarVim-mono/archive/refs/tags/stable.tar.gz"
  version "1.3.0"
  sha256 "4b63e968655d9a71ff32fdca653a56bd560555c1780d704669df578048b5f808"
  license "GPL-3.0-or-later"
  head "https://github.com/LunarVim/LunarVim-mono.git", branch: "master"

  depends_on "cmake" => :build
  depends_on "fd"
  depends_on "neovim"
  depends_on "node"
  depends_on "python@3.11"
  depends_on "ripgrep"
  depends_on "tree-sitter"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert shell_output("#{bin}/lvim -v").start_with?("NVIM")
    assert_equal "lmao", pipe_output("#{bin}/lvim -Es +%print", "lmao\n").strip
  end
end
