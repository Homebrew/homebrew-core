class CarthageCopyFrameworks < Formula
  include Language::Python::Virtualenv

  desc "Helper to sign and bundle frameworks built by Carthage"
  homepage "https://github.com/lvillani/carthage-copy-frameworks"
  url "https://github.com/lvillani/carthage-copy-frameworks/archive/v1.2.0.tar.gz"
  sha256 "15835dffff329aa931209d184fd43a831a894594b80c2a52843e1f5f25fe2e7f"
  head "https://github.com/lvillani/carthage-copy-frameworks.git"

  def install
    virtualenv_install_with_resources
  end
end
