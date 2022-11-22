class JenkinsJobBuilder < Formula
  include Language::Python::Virtualenv

  desc "Configure Jenkins jobs with YAML files stored in Git"
  homepage "https://docs.openstack.org/infra/jenkins-job-builder/"
  url "https://files.pythonhosted.org/packages/45/9b/bf0f284d27fd41707d849126b5bac29a1a02919304372a334ed869613318/jenkins-job-builder-4.1.0.tar.gz"
  sha256 "e630a5b5da260f8bb92d9ad824550707fb0b3915d8b96a1e24e6a501c8b4f974"
  license "Apache-2.0"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1db587e3f2322b6b3cf75ab30993008b12e2c4f2c3eab6a9941211b85dc84c2c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e68aeb1306e7d5b3b07d1e6c6eb4121f11a3306a082250b6da684702fd0f2afb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cae82ede6ac57d56ae9f8e507bd890365036fb45bb989f7a829a5241e8a68d35"
    sha256 cellar: :any_skip_relocation, ventura:        "2a6ccbc82b33735df0e64039044d486ffb5579363eae888146c9a40435513192"
    sha256 cellar: :any_skip_relocation, monterey:       "325fc32604dd452eee660da4be8e10d0635cb0c86542b64b0805a54fc09fdf9b"
    sha256 cellar: :any_skip_relocation, big_sur:        "63042b584656c8f987289298d8723778bab8af7461d118c1cd42f49cf8958f01"
    sha256 cellar: :any_skip_relocation, catalina:       "dbb9684dc8dce274e52388e7d89b0617e376eb63a2e7cf0aea8d63272cf9679c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d9ebeb0bb6b29520e93048a242bfbce9a241dafa7b8d7d762e243f5cd9ac1dab"
  end

  depends_on "python@3.11"
  depends_on "pyyaml"
  depends_on "six"

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/cb/a4/7de7cd59e429bd0ee6521ba58a75adaec136d32f91a761b28a11d8088d44/certifi-2022.9.24.tar.gz"
    sha256 "0d9c601124e5a6ba9712dbc60d9c53c21e34f5f641fe83002317394311bdce14"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/a1/34/44964211e5410b051e4b8d2869c470ae8a68ae274953b1c7de6d98bbcf94/charset-normalizer-2.1.1.tar.gz"
    sha256 "5a3d016c7c547f69d6f81fb0db9449ce888b418b5b9952cc5e6e66843e9dd845"
  end

  resource "fasteners" do
    url "https://files.pythonhosted.org/packages/f5/9a/e613fc7f7fa157bea028d8d823a13ba5583a49a2dea926ca86b6cbf0fd00/fasteners-0.18.tar.gz"
    sha256 "cb7c13ef91e0c7e4fe4af38ecaf6b904ec3f5ce0dda06d34924b6b74b869d953"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "Jinja2" do
    url "https://files.pythonhosted.org/packages/7a/ff/75c28576a1d900e87eb6335b063fab47a8ef3c8b4d88524c4bf78f670cce/Jinja2-3.1.2.tar.gz"
    sha256 "31351a702a408a9e7595a8fc6150fc3f43bb6bf7e319770cbc0db9df9437e852"
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
    url "https://files.pythonhosted.org/packages/52/fb/630d52aaca8fc7634a0711b6ae12a0e828b6f9264bd8051225025c3ed075/pbr-5.11.0.tar.gz"
    sha256 "b97bc6695b2aff02144133c2e7399d5885223d42b7912ffaec2ca3898e673bfe"
  end

  resource "python-jenkins" do
    url "https://files.pythonhosted.org/packages/85/8e/52223d8eebe35a3d86579df49405f096105328a9d80443eaed809f6c374f/python-jenkins-1.7.0.tar.gz"
    sha256 "deed8fa79d32769a615984a5dde5e01eda04914d3f4091bd9a23d30474695106"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/a5/61/a867851fd5ab77277495a8709ddda0861b28163c4613b011bc00228cc724/requests-2.28.1.tar.gz"
    sha256 "7c5599b102feddaa661c826c56ab4fee28bfd17f5abca1ebbe3e7f19d7c97983"
  end

  resource "stevedore" do
    url "https://files.pythonhosted.org/packages/62/4c/5445ea215b920e55f40a4f519571d5bfffb81c2f0c9ba4f2c70b1b501954/stevedore-4.1.0.tar.gz"
    sha256 "02518a8f0d6d29be8a445b7f2ac63753ff29e8f2a2faa01777568d5500d777a6"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/b2/56/d87d6d3c4121c0bcec116919350ca05dc3afd2eeb7dc88d07e8083f8ea94/urllib3-1.26.12.tar.gz"
    sha256 "3fa96cf423e6987997fc326ae8df396db2a8b7c667747d47ddd8ecba91f4a74e"
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
