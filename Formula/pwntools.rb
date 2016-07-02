class Pwntools < Formula
  desc "CTF framework used by Gallopsled in every CTF"
  homepage "https://pwntools.com/"
  url "https://github.com/Gallopsled/pwntools/archive/2.3.0.tar.gz"
  sha256 "2485405a31ccd4d5ddbe6d2551a9518807bbdc4f8bb3f88d31f2429ae292a233"

  bottle do
    cellar :any_skip_relocation
    sha256 "a517beade37686ae71738427c180e18efafecd4ca56294fcbe9f6ce6c12029a5" => :el_capitan
    sha256 "affb589f197e7c1aa621941d522ee66e73eba82fcfe233d41127f09df740afc4" => :yosemite
    sha256 "99bee1cf46e373deda65b22b8217be9439e009c57a1cebeb8b28a8e6c986b5fb" => :mavericks
  end

  depends_on :python if MacOS.version <= :snow_leopard
  depends_on "binutils" => :recommended

  resource "paramiko" do
    url "https://pypi.python.org/packages/source/p/paramiko/paramiko-1.15.2.tar.gz"
    sha256 "4f56a671a3eecbb76e6143e6e4ca007d503a39aa79aa9e14ade667fa53fd6e55"
  end

  resource "argparse" do
    url "https://pypi.python.org/packages/source/a/argparse/argparse-1.3.0.tar.gz"
    sha256 "b3a79a23d37b5a02faa550b92cbbbebeb4aa1d77e649c3eb39c19abf5262da04"
  end

  resource "mako" do
    url "https://pypi.python.org/packages/source/M/Mako/Mako-1.0.0.tar.gz"
    sha256 "a3cd72cfef507204b50f74ffcbfcfde7e856437891d3f6cfe780866986d006fe"
  end

  resource "pyelftools" do
    url "https://pypi.python.org/packages/source/p/pyelftools/pyelftools-0.23.tar.gz"
    sha256 "fc57aadd096e8f9b9b03f1a9578f673ee645e1513a5ff0192ef439e77eab21de"
  end

  # Don't bump this beyond 2.1.
  resource "capstone" do
    url "https://pypi.python.org/packages/source/c/capstone/capstone-2.1.tar.gz"
    sha256 "b86ba2b9189fe60e286341da75d0ac24322014303f72ab3d6ba3d800f3af7864"
  end

  resource "ropgadget" do
    url "https://github.com/JonathanSalwan/ROPgadget/archive/v5.3.tar.gz"
    sha256 "809090fe07705b222923b64585c2447a2d7fd3b15468be614e3d0b776966c143"
  end

  resource "pyserial" do
    url "https://pypi.python.org/packages/source/p/pyserial/pyserial-2.7.tar.gz"
    sha256 "3542ec0838793e61d6224e27ff05e8ce4ba5a5c5cc4ec5c6a3e8d49247985477"
  end

  resource "requests" do
    url "https://pypi.python.org/packages/source/r/requests/requests-2.6.0.tar.gz"
    sha256 "1cdbed1f0e236f35ef54e919982c7a338e4fea3786310933d3a7887a04b74d75"
  end

  resource "psutil" do
    url "https://pypi.python.org/packages/source/p/psutil/psutil-2.2.0.tar.gz"
    sha256 "b15cc9e7cad0991bd1cb806fa90ea85ba3a95d0f1226625ecef993294ad61521"
  end

  resource "markupsafe" do
    url "https://pypi.python.org/packages/source/M/MarkupSafe/MarkupSafe-0.23.tar.gz"
    sha256 "a4ec1aff59b95a14b45eb2e23761a0179e98319da5a7eb76b56ea8cdc7b871c3"
  end

  resource "ecdsa" do
    url "https://pypi.python.org/packages/source/e/ecdsa/ecdsa-0.11.tar.gz"
    sha256 "8e3b6c193f91dc94b2f3b0261e3eabbdc604f78ff99fdad324a56fdd0b5e958c"
  end

  # Don't bump this beyond 2.3.
  resource "pycrypto" do
    url "https://pypi.python.org/packages/source/p/pycrypto/pycrypto-2.3.tar.gz"
    sha256 "4f11e85fbcf13960373650fc2dae8f088f9b001f07fb6d3efb2fcb5334987182"
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"
    %w[paramiko argparse mako pyelftools capstone ropgadget pyserial requests psutil markupsafe ecdsa pycrypto].each do |r|
      resource(r).stage do
        system "python", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"
    system "python", *Language::Python.setup_install_args(libexec)

    bin.install Dir["#{libexec}/bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    ENV["TERM"] = "xterm"
    assert_equal "686f6d6562726577696e7374616c6c636f6d706c657465",
      shell_output("#{bin}/hex homebrewinstallcomplete").strip
  end
end
