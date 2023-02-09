class Geometry < Formula
  desc "Minimal, fully customizable and composable zsh prompt theme"
  homepage "https://github.com/geometry-zsh/geometry"
  url "https://github.com/geometry-zsh/geometry/archive/v2.0.0.tar.gz"
  sha256 "47c9fd345e5e8f093ae735a91fe5a9a9a6e3c1873eab220a7846a17b8405de02"
  license "ISC"
  head "https://github.com/geometry-zsh/geometry.git", branch: "main"

  depends_on "zsh-async"
  uses_from_macos "expect" => :test
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
    (testpath/"prompt.exp").write <<~EOS
      set timeout 1
      spawn zsh
      expect {
        "▲" { exit 0 }
        default { exit 1 }
      }
    EOS

    system "expect", "-f", "prompt.exp"
  end
end
