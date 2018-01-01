class Ccm < Formula
  desc "Create and destroy an Apache Cassandra cluster on localhost"
  homepage "https://github.com/pcmanus/ccm"
  url "https://files.pythonhosted.org/packages/f1/4b/04f57158a0fb15473c37096b8beca725321bf969f15b7d190333ab019c94/ccm-3.1.1.tar.gz"
  sha256 "49e07fee97c1df10b2d60c9ffcb1e5d4d12a4d9d18148ae1995bb8d3d72eeed3"
  head "https://github.com/pcmanus/ccm.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "8f73952bcc0d887ff7a61f8bd1564c7e8b2f0c30f8afc9adcb7d356677a5c48d" => :high_sierra
    sha256 "8f73952bcc0d887ff7a61f8bd1564c7e8b2f0c30f8afc9adcb7d356677a5c48d" => :sierra
    sha256 "e67cdfb7a939bfcc42fac077560bd3f871cd1a8de9bc34001139b4f2f71f0fd4" => :el_capitan
  end

  depends_on "python" if MacOS.version <= :snow_leopard

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/4a/85/db5a2df477072b2902b0eb892feb37d88ac635d36245a72a6a69b23b383a/PyYAML-3.12.tar.gz"
    sha256 "592766c6303207a20efc445587778322d7f73b161bd994f227adaa341ba212ab"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/16/d8/bc6316cf98419719bd59c91742194c111b6f2e85abac88e496adefaf7afe/six-1.11.0.tar.gz"
    sha256 "70e8a77beed4562e7f14fe23a786b54f6296e34344c23bc42f07b15018ff98e9"
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
