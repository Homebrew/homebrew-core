class Ccm < Formula
  desc "Create and destroy an Apache Cassandra cluster on localhost"
  homepage "https://github.com/pcmanus/ccm"
  url "https://files.pythonhosted.org/packages/e7/8c/f9a6b7338615baf3992d50a497aa4408e4a1d5356869dd27da3455fe2992/ccm-3.0.1.tar.gz"
  sha256 "2e15759159b9b4e68ef97f5a85e3a65d43486ae9f23f450971d93e4f885d014c"
  head "https://github.com/pcmanus/ccm.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "aba09d9efe714ff267a97ab20b6d6213c3f6b9f2c533bd11c4437d120ccb78e5" => :high_sierra
    sha256 "e4a73a374d6486c787448aae5ee1b92739d74f57096a84db3dfe39f6a22866b6" => :sierra
    sha256 "0e459b19c10d2def953a09d92ff3892b1048ff4c20fc381b83f8b7dc1cf12048" => :el_capitan
    sha256 "0e459b19c10d2def953a09d92ff3892b1048ff4c20fc381b83f8b7dc1cf12048" => :yosemite
  end

  depends_on :python if MacOS.version <= :snow_leopard

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/4a/85/db5a2df477072b2902b0eb892feb37d88ac635d36245a72a6a69b23b383a/PyYAML-3.12.tar.gz"
    sha256 "592766c6303207a20efc445587778322d7f73b161bd994f227adaa341ba212ab"
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
