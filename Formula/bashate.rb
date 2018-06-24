class Bashate < Formula
  include Language::Python::Virtualenv

  desc "Code style enforcement for bash programs"
  homepage "https://github.com/openstack-dev/bashate"
  url "https://github.com/openstack-dev/bashate/archive/0.5.1.tar.gz"
  sha256 "44fa6645fd7d5169c40747714986f1093ed24e2474e4a368c2695bf339c1551e"

  depends_on "python@2" if MacOS.version <= :snow_leopard

  resource "pbr" do
    url "https://files.pythonhosted.org/packages/cd/9f/8f14a51b522c47a315dd969fbdf39233e41f0bfa8b996b4ff0ad852ff43d/pbr-4.0.4.tar.gz"
    sha256 "a9c27eb8f0e24e786e544b2dbaedb729c9d8546342b5a6818d8eda098ad4340d"
  end

  def install
    ENV.append("PBR_VERSION", "0.5.1")
    virtualenv_install_with_resources
  end

  test do
    (testpath/"test.sh").write <<~EOS
      #!/bin/bash
      echo "Testing Bashate"
    EOS
    system "#{bin}/bashate", testpath/"test.sh"
  end
end
