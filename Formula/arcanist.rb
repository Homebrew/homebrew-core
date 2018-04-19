class Arcanist < Formula
  desc "Phabricator Arcanist Tool"
  homepage "https://secure.phabricator.com/book/phabricator/article/arcanist/"

  stable do
    url "https://github.com/wikimedia/arcanist/archive/release/2018-04-12/1.tar.gz"
    sha256 "7084008e79f47858a1acaa21361bc0b0900394e6daff6e68bb2ac821738aab68"
    version "20180412"

    resource "libphutil" do
      url "https://github.com/wikimedia/phabricator-libphutil/archive/release/2018-04-12/1.tar.gz"
      sha256 "d4f5eabac9cbd4ef5bac3743a7bd4865dee556e8ff0ef408666e087c4d88820e"
      version "20180412"
    end
  end

  def install
    libexec.install Dir["*"]

    resource("libphutil").stage do
      (buildpath/"libphutil").install Dir["*"]
    end

    prefix.install Dir["*"]

    bin.install_symlink libexec/"bin/arc" => "arc"

    cp libexec/"resources/shell/bash-completion", libexec/"resources/shell/arc-completion.zsh"
    bash_completion.install libexec/"resources/shell/bash-completion" => "arc"
    zsh_completion.install libexec/"resources/shell/arc-completion.zsh" => "_arc"
  end

  test do
    system "#{bin}/arc", "help"
  end
end
