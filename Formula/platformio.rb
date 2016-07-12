class Platformio < Formula
  desc "Ecosystem for IoT development (Arduino and ARM mbed compatible)"
  homepage "http://platformio.org"
  url "https://pypi.python.org/packages/31/d9/9d06e2b531028772650dc3a79dd770fcc12e1265d877b9de0ad455217f1c/platformio-2.11.1.tar.gz"
  sha256 "26e64cf0aed9fef2b6a7be6e907a0f347885b7610da80244c6fc63e72671ab89"

  bottle do
    cellar :any_skip_relocation
    sha256 "4f559f10ec30f8ad034adde2951f2a2cafe63697f68e4175e11178cdf3f79ad8" => :el_capitan
    sha256 "e3752e600bc40d7d9b632ef61a18f959f541d5317dd324a30e40cf9276ef87bf" => :yosemite
    sha256 "ca4f8deddf960ce82761815d145dc27abbc8e0d28711779884e9e0c6ceb68f35" => :mavericks
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
    url "https://pypi.python.org/packages/3c/d8/a9fa247ca60b02b3bebbd61766b4f321393b57b13c53b18f6f62cf172c08/pyserial-3.1.1.tar.gz"
    sha256 "d657051249ce3cbd0446bcfb2be07a435e1029da4d63f53ed9b4cdde7373364c"
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
