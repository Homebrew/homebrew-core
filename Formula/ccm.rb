class Ccm < Formula
  desc "Create and destroy an Apache Cassandra cluster on localhost"
  homepage "https://github.com/pcmanus/ccm"
  url "https://files.pythonhosted.org/packages/c6/11/f9d69d65ca3f8995aea37d94c8636b3662340a355ab61b583316a1cc36d1/ccm-2.1.6.tar.gz"
  sha256 "16b1d1db66239e7af801ec1a6d4fc796c0155243db40676064648e597577ed9c"
  head "https://github.com/pcmanus/ccm.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "19ee206337025ca0e62f84869b8eb95d2453ae49e1747f4a55ba8e0921859995" => :el_capitan
    sha256 "8655aa728be65e6a231da79889fdf82e0d2b9f48e2a048ef83ad36154e3068ec" => :yosemite
    sha256 "46d15b6f0f213b3b4228bb83f744326edf0ef443b80e7990d338e722150102b6" => :mavericks
    sha256 "d2f00ee08b94a6d26bc6ef4004c8c68b6365c7de0ff88e0aa57b9d326e85cfd8" => :mountain_lion
  end

  depends_on :python if MacOS.version <= :snow_leopard

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/75/5e/b84feba55e20f8da46ead76f14a3943c8cb722d40360702b2365b91dec00/PyYAML-3.11.tar.gz"
    sha256 "c36c938a872e5ff494938b33b14aaa156cb439ec67548fcab3535bb78b0846e8"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/b3/b2/238e2590826bfdd113244a40d9d3eb26918bd798fc187e2360a8367068db/six-1.10.0.tar.gz"
    sha256 "105f8d68616f8248e24bf0e9372ef04d3cc10104f1980f54d57b2ce73a5ad56a"
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"
    %w[PyYAML six].each do |r|
      resource(r).stage do
        system "python", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"
    system "python", *Language::Python.setup_install_args(libexec)

    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    assert_match "Usage", shell_output("#{bin}/ccm", 1)
  end
end
