class JenkinsJobBuilder < Formula
  desc "Configure Jenkins jobs with YAML files stored in Git"
  homepage "https://docs.openstack.org/infra/system-config/jjb.html"
  url "https://files.pythonhosted.org/packages/90/a6/dd9f719cababf5de1369d2cc2bd4775a7cbd4d3b0d377ffa50678ad94907/jenkins-job-builder-2.0.5.tar.gz"
  sha256 "ddb163fdd252b60fe9fc38c6e417433d32a646d6f3e5b9ab38d060eb419878e8"

  bottle do
    cellar :any_skip_relocation
    sha256 "3cb6ec620432da20dff244bba2f042e058b98521b399332e11c9132b64dd8a23" => :high_sierra
    sha256 "2f171ce8e6adad8318d8db795ff2647791b1eb7201947d79f9c79c49f69d1ee4" => :sierra
    sha256 "d970b78322f261b738c0a3152a53bc8b34d7babbae18cab48d28189f331af143" => :el_capitan
  end

  depends_on "python@2" if MacOS.version <= :snow_leopard

  resource "fasteners" do
    url "https://files.pythonhosted.org/packages/f4/6f/41b835c9bf69b03615630f8a6f6d45dafbec95eb4e2bb816638f043552b2/fasteners-0.14.1.tar.gz"
    sha256 "427c76773fe036ddfa41e57d89086ea03111bbac57c55fc55f3006d027107e18"
  end

  resource "Jinja2" do
    url "https://files.pythonhosted.org/packages/56/e6/332789f295cf22308386cf5bbd1f4e00ed11484299c5d7383378cf48ba47/Jinja2-2.10.tar.gz"
    sha256 "f84be1bb0040caca4cea721fcbbbbd61f9be9464ca236387158b0feea01914a4"
  end

  resource "MarkupSafe" do
    url "https://files.pythonhosted.org/packages/4d/de/32d741db316d8fdb7680822dd37001ef7a448255de9699ab4bfcbdf4172b/MarkupSafe-1.0.tar.gz"
    sha256 "a6be69091dac236ea9c6bc7d012beab42010fa914c459791d627dad4910eb665"
  end

  resource "monotonic" do
    url "https://files.pythonhosted.org/packages/14/73/04da85fc1bacfa94361f00205a464b7f1ed23bfe8de3511cbff0fa2eeda7/monotonic-1.4.tar.gz"
    sha256 "a02611d5b518cd4051bf22d21bd0ae55b3a03f2d2993a19b6c90d9d168691f84"
  end

  resource "multi_key_dict" do
    url "https://files.pythonhosted.org/packages/6d/97/2e9c47ca1bbde6f09cb18feb887d5102e8eacd82fbc397c77b221f27a2ab/multi_key_dict-2.0.3.tar.gz"
    sha256 "deebdec17aa30a1c432cb3f437e81f8621e1c0542a0c0617a74f71e232e9939e"
  end

  resource "pbr" do
    url "https://files.pythonhosted.org/packages/71/99/bbe0ed2c7077da3af0d7439127d215d4b90ebc8c8d096d2e39fc7e614d1f/pbr-4.0.1.tar.gz"
    sha256 "56b7a8ba7d64bf6135a9dfefb85a80d95924b3fde5ed6343a1a1d464a040dae3"
  end

  resource "python-jenkins" do
    url "https://files.pythonhosted.org/packages/15/dd/8dc3f8dca1532401ff06b2e0f29784e894f5def08223a24c722378a93905/python-jenkins-0.4.16.tar.gz"
    sha256 "af899c4fb773a97acc920dc329dcc39f8bc6d2b3b6c7ad231d46f2eb370f9ab3"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/4a/85/db5a2df477072b2902b0eb892feb37d88ac635d36245a72a6a69b23b383a/PyYAML-3.12.tar.gz"
    sha256 "592766c6303207a20efc445587778322d7f73b161bd994f227adaa341ba212ab"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/16/d8/bc6316cf98419719bd59c91742194c111b6f2e85abac88e496adefaf7afe/six-1.11.0.tar.gz"
    sha256 "70e8a77beed4562e7f14fe23a786b54f6296e34344c23bc42f07b15018ff98e9"
  end

  resource "stevedore" do
    url "https://files.pythonhosted.org/packages/ba/40/92295187c3157c109fde84eb2d4002c2bb3ab5a9c1df09f7fd96e6dfd5c9/stevedore-1.28.0.tar.gz"
    sha256 "f1c7518e7b160336040fee272174f1f7b29a46febb3632502a8f2055f973d60b"
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"
    resources.each do |resource|
      resource.stage do
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
