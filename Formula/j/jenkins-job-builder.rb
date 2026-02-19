class JenkinsJobBuilder < Formula
  include Language::Python::Virtualenv

  desc "Configure Jenkins jobs with YAML files stored in Git"
  homepage "https://docs.openstack.org/infra/jenkins-job-builder/"
  url "https://files.pythonhosted.org/packages/bc/1d/66a4e12c3e93716130bc6a8eba717216e9ccb0b5b5f5f1e1c7d8e262a30a/jenkins_job_builder-6.4.4.tar.gz"
  sha256 "ecfa420e97b728b469b7e47f36efaac5d0f12ca595a938823cade3fa735aba6f"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b439c039a35d760e22b0e72074231a60ebde6b8c0b0e5871b5db0cf95fd85563"
    sha256 cellar: :any,                 arm64_sequoia: "df8690860e416c892b4af05597099d9449eec7469a515b7984c117b76ed1361b"
    sha256 cellar: :any,                 arm64_sonoma:  "d15d13475cc7cc6c4311275f8fcdf3a5b67b20ac75d018b2e74dd71f70b7e829"
    sha256 cellar: :any,                 sonoma:        "f1fb505216a8345c58cc6bd15d3b9647db938b55ab1fb9252e6899e7790a2bc7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "19c0a0f41a969499dd996559ebea537381d9898fe203a2e9dd0ec09fbae66e25"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4ea1e152ff095cfc65a624f312ae43b5fafecefbef928009a3db311e2488c7ed"
  end

  depends_on "certifi"
  depends_on "libyaml"
  depends_on "python@3.14"

  pypi_packages exclude_packages: "certifi"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/13/69/33ddede1939fdd074bce5434295f38fae7136463422fe4fd3e0e89b98062/charset_normalizer-3.4.4.tar.gz"
    sha256 "94537985111c35f28720e43603b8e7b43a6ecfb2ce1d3058bbe955b73404e21a"
  end

  resource "fasteners" do
    url "https://files.pythonhosted.org/packages/2d/18/7881a99ba5244bfc82f06017316ffe93217dbbbcfa52b887caa1d4f2a6d3/fasteners-0.20.tar.gz"
    sha256 "55dce8792a41b56f727ba6e123fcaee77fd87e638a6863cec00007bfea84c8d8"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/6f/6d/0703ccc57f3a7233505399edb88de3cbd678da106337b9fcde432b65ed60/idna-3.11.tar.gz"
    sha256 "795dafcc9c04ed0c1fb032c2aa73654d8e8c5023a7df64a53f39190ada629902"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/df/bf/f7da0350254c0ed7c72f3e33cef02e048281fec7ecec5f032d4aac52226b/jinja2-3.1.6.tar.gz"
    sha256 "0137fb05990d35f1275a587e9aee6d56da821fc83491a0fb838183be43f66d6d"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/7e/99/7690b6d4034fffd95959cbe0c02de8deb3098cc577c67bb6a24fe5d7caa7/markupsafe-3.0.3.tar.gz"
    sha256 "722695808f4b6457b320fdc131280796bdceb04ab50fe1795cd540799ebe1698"
  end

  resource "multi-key-dict" do
    url "https://files.pythonhosted.org/packages/6d/97/2e9c47ca1bbde6f09cb18feb887d5102e8eacd82fbc397c77b221f27a2ab/multi_key_dict-2.0.3.tar.gz"
    sha256 "deebdec17aa30a1c432cb3f437e81f8621e1c0542a0c0617a74f71e232e9939e"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/a1/d4/1fc4078c65507b51b96ca8f8c3ba19e6a61c8253c72794544580a7b6c24d/packaging-25.0.tar.gz"
    sha256 "d443872c98d677bf60f6a1f2f8c1cb748e8fe762d2bf9d3148b5599295b0fc4f"
  end

  resource "pbr" do
    url "https://files.pythonhosted.org/packages/5e/ab/1de9a4f730edde1bdbbc2b8d19f8fa326f036b4f18b2f72cfbea7dc53c26/pbr-7.0.3.tar.gz"
    sha256 "b46004ec30a5324672683ec848aed9e8fc500b0d261d40a3229c2d2bbfcedc29"
  end

  resource "python-jenkins" do
    url "https://files.pythonhosted.org/packages/46/e8/4cb6c251d32b440bdd5400b53ed7941d7e9301011f805d0b89d6987fc978/python_jenkins-1.8.3.tar.gz"
    sha256 "8f4761c391ac11e8c1f23f771010920c10440497705ab7175d52358f5a12dc98"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/c9/74/b3ff8e6c8446842c3f5c837e9c3dfcfe2018ea6ecef224c710c85ef728f4/requests-2.32.5.tar.gz"
    sha256 "dbba0bac56e100853db0ea71b82b4dfd5fe2bf6d3754a8893c3af500cec7d7cf"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/18/5d/3bf57dcd21979b887f014ea83c24ae194cfcd12b9e0fda66b957c69d1fca/setuptools-80.9.0.tar.gz"
    sha256 "f36b47402ecde768dbfafc46e8e4207b4360c654f1f3bb84475f0a28628fb19c"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "stevedore" do
    url "https://files.pythonhosted.org/packages/96/5b/496f8abebd10c3301129abba7ddafd46c71d799a70c44ab080323987c4c9/stevedore-5.6.0.tar.gz"
    sha256 "f22d15c6ead40c5bbfa9ca54aa7e7b4a07d59b36ae03ed12ced1a54cf0b51945"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/c7/24/5f1b3bdffd70275f6661c76461e25f024d5a38a46f04aaca912426a2b1d3/urllib3-2.6.3.tar.gz"
    sha256 "1b62b6884944a57dbe321509ab94fd4d3b307075e0c2eae991ac71ee15ad38ed"
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

    output = shell_output("#{bin}/jenkins-jobs --version")
    assert_match "Jenkins Job Builder version: #{version}", output
  end
end
