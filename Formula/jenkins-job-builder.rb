class JenkinsJobBuilder < Formula
  include Language::Python::Virtualenv

  desc "Configure Jenkins jobs with YAML files stored in Git"
  homepage "https://docs.openstack.org/infra/jenkins-job-builder/"
  url "https://files.pythonhosted.org/packages/4d/5a/81443de7f0f9dfba3f133e3b3adb68420ba29bc7f6ea585824d0fe828dbf/jenkins-job-builder-4.0.0.tar.gz"
  sha256 "e9bb22ab72f094165d177efc1d710881948a7fb36c4e3a376db4a6b7b5e46203"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "da39c4bb38026e800d4fcf0a4c62ceb558ad7f2453daa44c4222c26a93ebed31"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "680f11e85f81de2968770b88130cdf6f3f56da4d8b501751322299b94b759952"
    sha256 cellar: :any_skip_relocation, monterey:       "eebde209fa415e4cdbcc41b3c7c05b7237032dc2ea57fcae43c1778858f03970"
    sha256 cellar: :any_skip_relocation, big_sur:        "d8b213668e803f7eaedbd764298f8cf04fb4b217d09a5fc0fcc6d26b8fc1748c"
    sha256 cellar: :any_skip_relocation, catalina:       "ee6d09c69e795caebf23c698e188d41693edc33c14a7b3eb91f2620467535852"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0eae7b9420f6b2e9253c3b5d99faec0256a21048461fd39abcbb3dfe1be1fb09"
  end

  depends_on "python@3.10"
  depends_on "six"

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/6c/ae/d26450834f0acc9e3d1f74508da6df1551ceab6c2ce0766a593362d6d57f/certifi-2021.10.8.tar.gz"
    sha256 "78884e7c1d4b00ce3cea67b44566851c4343c120abd683433ce934a68ea58872"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/56/31/7bcaf657fafb3c6db8c787a865434290b726653c912085fbd371e9b92e1c/charset-normalizer-2.0.12.tar.gz"
    sha256 "2857e29ff0d34db842cd7ca3230549d1a697f96ee6d3fb071cfa6c7393832597"
  end

  resource "fasteners" do
    url "https://files.pythonhosted.org/packages/bd/f4/148f44998c1bdb064a508e7cbcf9e50b34572b3d36fcc378a5d61b7dc8c5/fasteners-0.17.3.tar.gz"
    sha256 "a9a42a208573d4074c77d041447336cf4e3c1389a256fd3e113ef59cf29b7980"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/62/08/e3fc7c8161090f742f504f40b1bccbfc544d4a4e09eb774bf40aafce5436/idna-3.3.tar.gz"
    sha256 "9d643ff0a55b762d5cdb124b8eaa99c66322e2157b69160bc32796e824360e6d"
  end

  resource "Jinja2" do
    url "https://files.pythonhosted.org/packages/89/e3/b36266381ae7a1310a653bb85f4f3658c462a69634fa9b2fef76252a50ed/Jinja2-3.1.1.tar.gz"
    sha256 "640bed4bb501cbd17194b3cace1dc2126f5b619cf068a726b98192a0fde74ae9"
  end

  resource "MarkupSafe" do
    url "https://files.pythonhosted.org/packages/1d/97/2288fe498044284f39ab8950703e88abbac2abbdf65524d576157af70556/MarkupSafe-2.1.1.tar.gz"
    sha256 "7f91197cc9e48f989d12e4e6fbc46495c446636dfc81b9ccf50bb0ec74b91d4b"
  end

  resource "multi_key_dict" do
    url "https://files.pythonhosted.org/packages/6d/97/2e9c47ca1bbde6f09cb18feb887d5102e8eacd82fbc397c77b221f27a2ab/multi_key_dict-2.0.3.tar.gz"
    sha256 "deebdec17aa30a1c432cb3f437e81f8621e1c0542a0c0617a74f71e232e9939e"
  end

  resource "pbr" do
    url "https://files.pythonhosted.org/packages/51/da/eb358ed53257a864bf9deafba25bc3d6b8d41b0db46da4e7317500b1c9a5/pbr-5.8.1.tar.gz"
    sha256 "66bc5a34912f408bb3925bf21231cb6f59206267b7f63f3503ef865c1a292e25"
  end

  resource "python-jenkins" do
    url "https://files.pythonhosted.org/packages/85/8e/52223d8eebe35a3d86579df49405f096105328a9d80443eaed809f6c374f/python-jenkins-1.7.0.tar.gz"
    sha256 "deed8fa79d32769a615984a5dde5e01eda04914d3f4091bd9a23d30474695106"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/a0/a4/d63f2d7597e1a4b55aa3b4d6c5b029991d3b824b5bd331af8d4ab1ed687d/PyYAML-5.4.1.tar.gz"
    sha256 "607774cbba28732bfa802b54baa7484215f530991055bb562efbed5b2f20a45e"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/60/f3/26ff3767f099b73e0efa138a9998da67890793bfa475d8278f84a30fec77/requests-2.27.1.tar.gz"
    sha256 "68d7c56fd5a8999887728ef304a6d12edc7be74f1cfa47714fc8b414525c9a61"
  end

  resource "stevedore" do
    url "https://files.pythonhosted.org/packages/67/73/cd693fde78c3b2397d49ad2c6cdb082eb0b6a606188876d61f53bae16293/stevedore-3.5.0.tar.gz"
    sha256 "f40253887d8712eaa2bb0ea3830374416736dc8ec0e22f5a65092c1174c44335"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/1b/a5/4eab74853625505725cefdf168f48661b2cd04e7843ab836f3f63abf81da/urllib3-1.26.9.tar.gz"
    sha256 "aabaf16477806a5e1dd19aa41f8c2b7950dd3c746362d7e3223dbe6de6ac448e"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    command = "#{bin}/jenkins-jobs test /dev/stdin 2>&1"
    if OS.mac?
      output = pipe_output(command, "- job: { name: test-job }", 0)
      assert_match "Managed by Jenkins Job Builder", output
    else
      output = pipe_output(command, "- job: { name: test-job }", 1)
      assert_match "WARNING:jenkins_jobs.config:Config file", output
    end
  end
end
