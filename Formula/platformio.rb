class Platformio < Formula
  desc "Ecosystem for IoT development (Arduino and ARM mbed compatible)"
  homepage "http://platformio.org"
  url "https://pypi.python.org/packages/4e/29/49972bac9706a618a58a396746a2004aa13f0540c68fc3bf411b17867b41/platformio-2.9.4.tar.gz"
  sha256 "3bef1e5f5c67aeef746a463db213af2d55ec355a6ac6da9735b5b8e701790217"

  bottle do
    cellar :any_skip_relocation
    sha256 "0f47497863a3a2f1ee44516474ce64fdb57cde359c2969f5c38fef29dd3c4466" => :el_capitan
    sha256 "86d1ac7b95a065a9792e9523025bb65fffc4398d84014f8d0294191f246e2b24" => :yosemite
    sha256 "e20a17168052bc8f6cd2124acfafd353f3714425f8035cf35a3dfb00b508fc6e" => :mavericks
  end

  depends_on :python if MacOS.version <= :snow_leopard

  resource "bottle" do
    url "https://pypi.python.org/packages/source/b/bottle/bottle-0.12.9.tar.gz"
    sha256 "fe0a24b59385596d02df7ae7845fe7d7135eea73799d03348aeb9f3771500051"
  end

  resource "click" do
    url "https://pypi.python.org/packages/source/c/click/click-5.1.tar.gz"
    sha256 "678c98275431fad324275dec63791e4a17558b40e5a110e20a82866139a85a5a"
  end

  resource "colorama" do
    url "https://pypi.python.org/packages/f0/d0/21c6449df0ca9da74859edc40208b3a57df9aca7323118c913e58d442030/colorama-0.3.7.tar.gz"
    sha256 "e043c8d32527607223652021ff648fbb394d5e19cba9f1a698670b338c9d782b"
  end

  resource "lockfile" do
    url "https://pypi.python.org/packages/source/l/lockfile/lockfile-0.12.2.tar.gz"
    sha256 "6aed02de03cba24efabcd600b30540140634fc06cfa603822d508d5361e9f799"
  end

  resource "pyserial" do
    url "https://pypi.python.org/packages/ce/9c/694ce79a9d4a164e109aeba1a40fba23336f3b7554978553e22a5d41d54d/pyserial-3.1.tar.gz"
    sha256 "c8ffdcbd8bfd308842409e558848c32aa3499a1bfe95a591e4210072b9520f1e"
  end

  resource "requests" do
    url "https://pypi.python.org/packages/49/6f/183063f01aae1e025cf0130772b55848750a2f3a89bfa11b385b35d7329d/requests-2.10.0.tar.gz"
    sha256 "63f1815788157130cee16a933b2ee184038e975f0017306d723ac326b5525b54"
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"
    resources.each do |r|
      r.stage do
        system "python", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"
    system "python", *Language::Python.setup_install_args(libexec)

    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    system bin/"platformio"
    system bin/"pio"
  end
end
