class JenkinsJobBuilder < Formula
  desc "Configure Jenkins jobs with YAML files stored in Git"
  homepage "https://docs.openstack.org/infra/jenkins-job-builder/"
  url "https://files.pythonhosted.org/packages/ff/0a/5ed164f5e10ff7841e6f408aaf29eac4a2ca4f5288aaf9cc2d7478d6b1a4/jenkins-job-builder-3.11.0.tar.gz"
  sha256 "42ea423f44beafee0e985009124968e300447f6e3be4180e83568cf21520d1b1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "35c8d22a60495e29b450dfd2220ee6f10aa77aad50bce893bd39a5433c285a6a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9ba53ae0b7014810b81813161316c9071c86b82600581ff5a70e24bec9f93fca"
    sha256 cellar: :any_skip_relocation, monterey:       "5016bc64c99ba56bab09a61065c500bd1ad481f375df0dcffd0e8c80530e3f7f"
    sha256 cellar: :any_skip_relocation, big_sur:        "110cb98febf8d9ffd03b562cb79f3bf2fa992cb9b036c3e0d74c3a8437e50431"
    sha256 cellar: :any_skip_relocation, catalina:       "37b7ddb8ab5d198557b9d6000ab2d9210e9686f9f37325973a6ecdbd987673e0"
    sha256 cellar: :any_skip_relocation, mojave:         "d4ec72cb626e3fd091c3ba0d077ce28914923e85dc6b23e40978faeef6ade89b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2682dcc83eb3304d98410c8844728d78acf496228c912d2b722c2feea4d7c287"
  end

  depends_on "python@3.9"
  depends_on "six"

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/6c/ae/d26450834f0acc9e3d1f74508da6df1551ceab6c2ce0766a593362d6d57f/certifi-2021.10.8.tar.gz"
    sha256 "78884e7c1d4b00ce3cea67b44566851c4343c120abd683433ce934a68ea58872"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/9f/c5/334c019f92c26e59637bb42bd14a190428874b2b2de75a355da394cf16c1/charset-normalizer-2.0.7.tar.gz"
    sha256 "e019de665e2bcf9c2b64e2e5aa025fa991da8720daa3c1138cadd2fd1856aed0"
  end

  resource "fasteners" do
    url "https://files.pythonhosted.org/packages/28/e4/2888d41cdbd405828ccdb9a8536c5919939c2f4c6ab9b2ba63e9bd2570d5/fasteners-0.16.3.tar.gz"
    sha256 "b1ab4e5adfbc28681ce44b3024421c4f567e705cc3963c732bf1cba3348307de"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/62/08/e3fc7c8161090f742f504f40b1bccbfc544d4a4e09eb774bf40aafce5436/idna-3.3.tar.gz"
    sha256 "9d643ff0a55b762d5cdb124b8eaa99c66322e2157b69160bc32796e824360e6d"
  end

  resource "Jinja2" do
    url "https://files.pythonhosted.org/packages/f8/86/7c0eb6e8b05385d1ce682abc0f994abd1668e148fb52603fa86e15d4c110/Jinja2-3.0.2.tar.gz"
    sha256 "827a0e32839ab1600d4eb1c4c33ec5a8edfbc5cb42dafa13b81f182f97784b45"
  end

  resource "MarkupSafe" do
    url "https://files.pythonhosted.org/packages/bf/10/ff66fea6d1788c458663a84d88787bae15d45daa16f6b3ef33322a51fc7e/MarkupSafe-2.0.1.tar.gz"
    sha256 "594c67807fb16238b30c44bdf74f36c02cdf22d1c8cda91ef8a0ed8dabf5620a"
  end

  resource "multi_key_dict" do
    url "https://files.pythonhosted.org/packages/6d/97/2e9c47ca1bbde6f09cb18feb887d5102e8eacd82fbc397c77b221f27a2ab/multi_key_dict-2.0.3.tar.gz"
    sha256 "deebdec17aa30a1c432cb3f437e81f8621e1c0542a0c0617a74f71e232e9939e"
  end

  resource "pbr" do
    url "https://files.pythonhosted.org/packages/35/8c/69ed04ae31ad498c9bdea55766ed4c0c72de596e75ac0d70b58aa25e0acf/pbr-5.6.0.tar.gz"
    sha256 "42df03e7797b796625b1029c0400279c7c34fd7df24a7d7818a1abb5b38710dd"
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
    url "https://files.pythonhosted.org/packages/e7/01/3569e0b535fb2e4a6c384bdbed00c55b9d78b5084e0fb7f4d0bf523d7670/requests-2.26.0.tar.gz"
    sha256 "b8aa58f8cf793ffd8782d3d8cb19e66ef36f7aba4353eec859e74678b01b07a7"
  end

  resource "stevedore" do
    url "https://files.pythonhosted.org/packages/f9/57/328653fd8a631d81b2d71261e471a102d5b64a95c1b1dda1a55b053bf0db/stevedore-3.4.0.tar.gz"
    sha256 "59b58edb7f57b11897f150475e7bc0c39c5381f0b8e3fa9f5c20ce6c89ec4aa1"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/80/be/3ee43b6c5757cabea19e75b8f46eaf05a2f5144107d7db48c7cf3a864f73/urllib3-1.26.7.tar.gz"
    sha256 "4987c65554f7a2dbf30c18fd48778ef124af6fab771a377103da0585e2336ece"
  end

  def install
    xy = Language::Python.major_minor_version "python3"
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python#{xy}/site-packages"
    resources.each do |resource|
      resource.stage do
        system "python3", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python#{xy}/site-packages"
    system "python3", *Language::Python.setup_install_args(libexec)

    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", PYTHONPATH: ENV["PYTHONPATH"])
  end

  test do
    on_macos do
      assert_match("Managed by Jenkins Job Builder",
                   pipe_output("#{bin}/jenkins-jobs test /dev/stdin",
                               "- job:\n    name: test-job\n\n", 0))
    end

    on_linux do
      assert_match("WARNING:jenkins_jobs.config:Config file",
               pipe_output("#{bin}/jenkins-jobs test /dev/stdin 2>&1",
                           "- job:\n    name: test-job\n\n", 1))
    end
  end
end
