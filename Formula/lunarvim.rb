class Lunarvim < Formula
  desc "IDE layer for Neovim with sane defaults"
  homepage "https://www.lunarvim.org"
  url "https://github.com/LunarVim/LunarVim/archive/refs/tags/1.1.4.tar.gz"
  sha256 "3ff64f075685565225b3d07b33844c75d0fda1e8682c822384997fecaedbe273"
  license "GPL-3.0-or-later"

  depends_on "neovim"
  depends_on "node"
  depends_on "python@3.10"
  depends_on "rust"

  def install
    inreplace "#{buildpath}/utils/bin/lvim.template" do |s|
      s.gsub!(/RUNTIME_DIR_VAR/, "\"#{share}\"")
      s.gsub!(/CONFIG_DIR_VAR/, "\"$HOME/.config/lvim\"")
      s.gsub!(/CACHE_DIR_VAR/, "\"$HOME/.cache/lvim\"")
    end

    share.mkpath

    lvim_root = share/"lvim"

    cp_r buildpath/".", lvim_root

    bin.mkpath
    bin.install lvim_root/"utils/bin/lvim.template" => "lvim"
  end

  test do
    assert_match shell_output("#{bin}/lvim -v").start_with? "NVIM"

    assert_equal "foo", pipe_output("#{bin}/lvim -Es +%print", "foo\n").strip
  end
end
