class Lime < Formula
  include Language::Python::Virtualenv

  desc "Experimental, stack-based, purely functional programming language"
  homepage "https://limelang.xyz"
  url "https://gitlab.com/lschumm/lime/-/archive/1.0.5/lime-1.0.5.tar.gz"
  sha256 "70ee5c0b364b1df5059c2eab54c40dae87c0f3ce26edb161058d9e625e993da0"

  def install
    virtualenv_install_with_resources
  end

  test do
    system "lime test"
  end
end
