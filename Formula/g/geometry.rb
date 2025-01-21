class Geometry < Formula
  desc "Minimal, fully customizable and composable zsh prompt theme"
  homepage "https://github.com/geometry-zsh/geometry"
  url "https://github.com/geometry-zsh/geometry/archive/refs/tags/v2.2.0.tar.gz"
  sha256 "2ffe63fbe83813e368933d2add79b7f6439c7ade4fcc8243cb0166c17178cd9a"
  license "ISC"
  head "https://github.com/geometry-zsh/geometry.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "fb4186111a4ac55abbf13a80026f3d8de8c1f53fb505ceb9ff9d186fb2539c8d"
  end

  depends_on "zsh-async"
  uses_from_macos "zsh" => :test

  def install
    pkgshare.install ["functions", "geometry.zsh"]
  end

  def caveats
    <<~EOS
      To activate Geometry, add the following to your .zshrc:
        source #{opt_pkgshare}/geometry.zsh
    EOS
  end

  test do
    (testpath/".zshrc").write "source #{opt_pkgshare}/geometry.zsh"

    require "expect"
    require "pty"
    PTY.spawn("zsh") do |r, w, _pid|
      refute_nil r.expect("▲", 1), "Zsh prompt missing ▲"
      w.write "exit\n"
    end
  end
end
