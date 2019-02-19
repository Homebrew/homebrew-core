class Lime < Formula
  include Language::Python::Virtualenv

  desc "Experimental, stack-based, purely functional programming language"
  homepage "https://limelang.xyz"
  url "https://gitlab.com/lschumm/lime/-/archive/1.0.5/lime-1.0.5.tar.gz"
  sha256 "307fc9742e2fd94bc124e73e7bd659a0e219309bd545a25e6b8aa119a4661bd1"

  def install
    virtualenv_install_with_resources
  end

  test do
    system "lime test"
  end
end
