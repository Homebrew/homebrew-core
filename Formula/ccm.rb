class Ccm < Formula
  desc "Create and destroy an Apache Cassandra cluster on localhost"
  homepage "https://github.com/pcmanus/ccm"
  url "https://files.pythonhosted.org/packages/9c/fb/090f431f2120ba269858b851d0e6b37bde87fd2e4cab80a0c94e783b232e/ccm-3.0.2.tar.gz"
  sha256 "bcd02fbc90bff81727b2ecea0e8c7ac2ebd8c04518f50c3b415ce0300fe84256"
  head "https://github.com/pcmanus/ccm.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "3b50660cddd9f82a585740e346662ba777094b374285bf3aaa1ce430d5a7badc" => :high_sierra
    sha256 "3b50660cddd9f82a585740e346662ba777094b374285bf3aaa1ce430d5a7badc" => :sierra
    sha256 "1ae37e7868644e03ccdf5f3c97ea1f7a883e39810383c93c204f097d89a17110" => :el_capitan
  end

  depends_on :python if MacOS.version <= :snow_leopard

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
