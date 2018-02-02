class Nyx < Formula
  desc "Command-line monitor for Tor"
  homepage "https://nyx.torproject.org/"
  url "https://files.pythonhosted.org/packages/42/37/85890dae5680f36f5b1c964ad41674ebb8d1186383fbca58f82e76de734c/nyx-2.0.4.tar.gz"
  sha256 "38db634789c2d72e485522a490397eb5f77c0bd7c689453efe57808c99dba75e"

  bottle do
    cellar :any_skip_relocation
    sha256 "144068c5ee35f582d8457cb5c57778447bda93cd73900eab42f061598391eaf1" => :high_sierra
    sha256 "144068c5ee35f582d8457cb5c57778447bda93cd73900eab42f061598391eaf1" => :sierra
    sha256 "8bea1e0d0e413854646f08dbd72ae94c147ede81157f4dca4e6118bbe14a9193" => :el_capitan
  end

  depends_on "python" if MacOS.version <= :snow_leopard

  resource "stem" do
    url "https://files.pythonhosted.org/packages/11/d5/e51983f81b38408ae2f0e166481ad867962f6fa07610fe71119534e12d41/stem-1.6.0.tar.gz"
    sha256 "d7fe1fb13ed5a94d610b5ad77e9f1b3404db0ca0586ded7a34afd323e3b849ed"
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"
    resource("stem").stage do
      system "python", *Language::Python.setup_install_args(libexec/"vendor")
    end

    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"
    system "python", *Language::Python.setup_install_args(libexec)

    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    assert_match "Errno 61", shell_output("#{bin}/nyx -i 127.0.0.1:9000", 1)
  end
end
