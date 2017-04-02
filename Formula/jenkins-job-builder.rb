class JenkinsJobBuilder < Formula
  desc "Configure Jenkins jobs with YAML files stored in Git"
  homepage "http://ci.openstack.org/jjb.html"
  url "https://pypi.python.org/packages/f1/ac/734f7dc9e16e725e2ff37eff4b87970a7a7fc69fbff977a4e5004fee0651/jenkins-job-builder-1.6.1.tar.gz"
  sha256 "64fa63ad18ae874dbb17bd96d3c74ea6ec31c4af91a83aac2de3eaf79d9d7dec"

  bottle do
    cellar :any_skip_relocation
    sha256 "299a6d4567c4a0907397c3b22b88c95782065bb3708df6a53589c25f9e3a3193" => :sierra
    sha256 "299a6d4567c4a0907397c3b22b88c95782065bb3708df6a53589c25f9e3a3193" => :el_capitan
    sha256 "299a6d4567c4a0907397c3b22b88c95782065bb3708df6a53589c25f9e3a3193" => :yosemite
  end

  depends_on :python if MacOS.version <= :snow_leopard

  resource "pyyaml" do
    url "http://pyyaml.org/download/pyyaml/PyYAML-3.12.tar.gz"
    sha256 "592766c6303207a20efc445587778322d7f73b161bd994f227adaa341ba212ab"
  end

  resource "ordereddict" do
    url "https://pypi.python.org/packages/source/o/ordereddict/ordereddict-1.1.tar.gz"
    sha256 "1c35b4ac206cef2d24816c89f89cf289dd3d38cf7c449bb3fab7bf6d43f01b1f"
  end

  resource "python-jenkins" do
    url "https://pypi.python.org/packages/61/f1/b2564dc961979a5f9e6cc206dd125add4164110993a6bffee2bb9f581c85/python-jenkins-0.4.13.tar.gz"
    sha256 "9d7b06d31db4734ba93c0238c1e3ba6a200d01ec02544368ff592f2b74a11fbc"
  end

  resource "pbr" do
    url "https://pypi.python.org/packages/c3/2c/63275fab26a0fd8cadafca71a3623e4d0f0ee8ed7124a5bb128853d178a7/pbr-1.10.0.tar.gz"
    sha256 "186428c270309e6fdfe2d5ab0949ab21ae5f7dea831eab96701b86bd666af39c"
  end

  resource "six" do
    url "https://pypi.python.org/packages/source/s/six/six-1.10.0.tar.gz"
    sha256 "105f8d68616f8248e24bf0e9372ef04d3cc10104f1980f54d57b2ce73a5ad56a"
  end

  resource "pip" do
    url "https://pypi.python.org/packages/source/p/pip/pip-7.1.2.tar.gz"
    sha256 "ca047986f0528cfa975a14fb9f7f106271d4e0c3fe1ddced6c1db2e7ae57a477"
  end

  resource "multi_key_dict" do
    url "https://pypi.python.org/packages/source/m/multi_key_dict/multi_key_dict-2.0.3.tar.gz"
    sha256 "deebdec17aa30a1c432cb3f437e81f8621e1c0542a0c0617a74f71e232e9939e"
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"
    %w[pyyaml ordereddict python-jenkins pbr six pip multi_key_dict].each do |r|
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
    assert_match(/Managed by Jenkins Job Builder/,
      pipe_output("#{bin}/jenkins-jobs test /dev/stdin",
                  "- job:\n    name: test-job\n\n", 0))
  end
end
