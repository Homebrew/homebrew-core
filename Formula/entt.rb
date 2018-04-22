class Entt < Formula
  desc "Fast and reliable entity-component system and much more"
  homepage "https://skypjack.github.io/entt/"
  url "https://github.com/skypjack/entt/archive/v2.5.0.tar.gz"
  sha256 "6246501c6589eba9832538c47a23a239eaa1066c77471cae7d79e741141ade82"

  def install
    include.install "src/entt"
  end

  test do
    system "true"
  end
end
