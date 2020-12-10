class NerdFontsPatcher < Formula
  desc "Patch your own font"
  homepage "https://github.com/ryanoasis/nerd-fonts#font-patcher"
  url "https://github.com/ryanoasis/nerd-fonts/trunk/src", using: :svn
  version = version "2.1.0"
  license "MIT"

  depends_on "fontforge"

  resource "script" do
    url "https://raw.githubusercontent.com/ryanoasis/nerd-fonts/v#{version}/font-patcher"
    sha256 "3377615be4271f8bdeef66e6f2f82ac3f3cfb7b5677abe7b8e189409da048859"
  end

  def install
    resource("script").stage { prefix.install "font-patcher" }
    mkdir "src"
    mv Dir["*"] - ["src"], "src"
    prefix.install "src"
    bin.write_exec_script prefix/"font-patcher"
    inreplace bin/"font-patcher", "exec", "exec #{HOMEBREW_PREFIX}/bin/fontforge -script"
  end

  test do
    font = prefix/"src/unpatched-fonts/FiraCode/Retina/FiraCode-Retina.ttf"
    system bin/"font-patcher", font, "--fontawesome", "--quiet", "--outputdir", testpath
    assert_predicate testpath/"Fira Code Retina Nerd Font Plus Font Awesome.ttf", :exist?
  end
end
