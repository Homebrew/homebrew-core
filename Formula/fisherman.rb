class Fisherman < Formula
  desc "fish plugin manager"
  homepage "https://github.com/fisherman/fisherman"

  url "https://raw.githubusercontent.com/fisherman/fisherman/2.12.0/fisher.fish"
  sha256 "3fa4c7c9a222dca46f7d279989ceb2fff1cc0f30e4f2815bbcd5afe7f8bc3d1e"

  head "https://github.com/fisherman/fisherman.git"

  depends_on "fish"

  def install
    (share/"fish/vendor_functions.d/").install "fisher.fish"
    File.write("fisher-completion.fish", "fisher --complete")
    fish_completion.install "fisher-completion.fish" => "fisher.fish"
    ohai "You may need to restart any open terminal sessions for changes to take effect."
  end
end
