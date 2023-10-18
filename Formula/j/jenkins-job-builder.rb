class JenkinsJobBuilder < Formula
  include Language::Python::Virtualenv

  desc "Configure Jenkins jobs with YAML files stored in Git"
  homepage "https://docs.openstack.org/infra/jenkins-job-builder/"
  url "https://files.pythonhosted.org/packages/74/e8/f559afa16434bd1280be101b24d2ea43cfbf5b4ad5a26cd4a5be86a60628/jenkins-job-builder-5.0.4.tar.gz"
  sha256 "fb3aec7f28b823cbde9c518c2970cc52afbdf9fef2e88639f72d7f3890c4c46b"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a643e36d233226d66d15adc47a6674a2841e9422f0c96fa5a01e0b3a1f731eed"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bd5a29ee02b11226c728bb9cf377f39c922843b7330b8f6e8bf0c346a2c9dd66"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c168543a625b04d8b2f5057e56ae82d52c83256e4143201084131dcc7bd8147b"
    sha256 cellar: :any_skip_relocation, sonoma:         "2be52bd629becad2a595c82c34780694fa832913070add0e89d10a1f6dbf3bf7"
    sha256 cellar: :any_skip_relocation, ventura:        "99fa2d745d77f8b196170a3e8c8895e2950103dd304edc6ad2167532f5e74200"
    sha256 cellar: :any_skip_relocation, monterey:       "385faef64b3aac70902ff3be8bb9dc187ccb03151cce2f72313b1037fd22ee68"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5931078022cd79751e59a6b6c6255084d848f414e07b361b18d1d129128c18d5"
  end

  depends_on "python-certifi"
  depends_on "python-setuptools"
  depends_on "python@3.12"
  depends_on "pyyaml"
  depends_on "six"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/cf/ac/e89b2f2f75f51e9859979b56d2ec162f7f893221975d244d8d5277aa9489/charset-normalizer-3.3.0.tar.gz"
    sha256 "63563193aec44bce707e0c5ca64ff69fa72ed7cf34ce6e11d5127555756fd2f6"
  end

  resource "fasteners" do
    url "https://files.pythonhosted.org/packages/5f/d4/e834d929be54bfadb1f3e3b931c38e956aaa3b235a46a3c764c26c774902/fasteners-0.19.tar.gz"
    sha256 "b4f37c3ac52d8a445af3a66bce57b33b5e90b97c696b7b984f530cf8f0ded09c"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/7a/ff/75c28576a1d900e87eb6335b063fab47a8ef3c8b4d88524c4bf78f670cce/Jinja2-3.1.2.tar.gz"
    sha256 "31351a702a408a9e7595a8fc6150fc3f43bb6bf7e319770cbc0db9df9437e852"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/6d/7c/59a3248f411813f8ccba92a55feaac4bf360d29e2ff05ee7d8e1ef2d7dbf/MarkupSafe-2.1.3.tar.gz"
    sha256 "af598ed32d6ae86f1b747b82783958b1a4ab8f617b06fe68795c7f026abbdcad"
  end

  resource "multi-key-dict" do
    url "https://files.pythonhosted.org/packages/6d/97/2e9c47ca1bbde6f09cb18feb887d5102e8eacd82fbc397c77b221f27a2ab/multi_key_dict-2.0.3.tar.gz"
    sha256 "deebdec17aa30a1c432cb3f437e81f8621e1c0542a0c0617a74f71e232e9939e"
  end

  resource "pbr" do
    url "https://files.pythonhosted.org/packages/02/d8/acee75603f31e27c51134a858e0dea28d321770c5eedb9d1d673eb7d3817/pbr-5.11.1.tar.gz"
    sha256 "aefc51675b0b533d56bb5fd1c8c6c0522fe31896679882e1c4c63d5e4a0fccb3"
  end

  resource "python-jenkins" do
    url "https://files.pythonhosted.org/packages/83/a9/ad5efdb48044b7a4045f0de1262262da746e02d0bedd8cb8725144f8736c/python-jenkins-1.8.1.tar.gz"
    sha256 "ff5f1d92539d903f869b02eaf2b1314447e6d6d78f767edcfdd92967d532b9c6"

    # setuptools patch to fix the conflict with jenkins-job-builder
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/08e835e/jenkins-job-builder/python-jenkins-1.8.1-setuptools.patch"
      sha256 "f3319463368d8ed133ade64e6a4c4f01a28d45e6993a38012a26be55d8d3e765"
    end
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "stevedore" do
    url "https://files.pythonhosted.org/packages/ac/d6/77387d3fc81f07bc8877e6f29507bd7943569093583b0a07b28cfa286780/stevedore-5.1.0.tar.gz"
    sha256 "a54534acf9b89bc7ed264807013b505bf07f74dbe4bcfa37d32bd063870b087c"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/8b/00/db794bb94bf09cadb4ecd031c4295dd4e3536db4da958e20331d95f1edb7/urllib3-2.0.6.tar.gz"
    sha256 "b19e1a85d206b56d7df1d5e683df4a7725252a964e3993648dd0fb5a1c157564"
  end

  # setuptools patch, upstream bug report, https://storyboard.openstack.org/#!/story/2010842
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/f4a0fb0/jenkins-job-builder/5.0.4-setuptools.patch"
    sha256 "35d06c1dbd44bd9cd36c188eaaddc846a4c64dbd5fc1fb1d3269e54de1f6e2b2"
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
