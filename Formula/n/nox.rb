class Nox < Formula
  include Language::Python::Virtualenv

  desc "Flexible test automation for Python"
  homepage "https://nox.thea.codes/"
  url "https://files.pythonhosted.org/packages/b4/80/47712208c410defec169992e57c179f0f4d92f5dd17ba8daca50a8077e23/nox-2025.5.1.tar.gz"
  sha256 "2a571dfa7a58acc726521ac3cd8184455ebcdcbf26401c7b737b5bc6701427b2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3e2714259195a768dc9390d04a0d2f9f0bcc1a1bd6cad293b3865a0b305eac9b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3e2714259195a768dc9390d04a0d2f9f0bcc1a1bd6cad293b3865a0b305eac9b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3e2714259195a768dc9390d04a0d2f9f0bcc1a1bd6cad293b3865a0b305eac9b"
    sha256 cellar: :any_skip_relocation, sonoma:        "f9718d5d586aad781bf74f6808694ffe294b2e7ef40e07bd185ced9c9831531c"
    sha256 cellar: :any_skip_relocation, ventura:       "f9718d5d586aad781bf74f6808694ffe294b2e7ef40e07bd185ced9c9831531c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8fe7df1af903820f571e1d6b1c08449a743f06e9908e1bcd6005eed4225a0140"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8fe7df1af903820f571e1d6b1c08449a743f06e9908e1bcd6005eed4225a0140"
  end

  depends_on "python@3.13"

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/16/0f/861e168fc813c56a78b35f3c30d91c6757d1fd185af1110f1aec784b35d0/argcomplete-3.6.2.tar.gz"
    sha256 "d0519b1bc867f5f4f4713c41ad0aba73a4a5f007449716b16f385f2166dc6adf"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/5a/b0/1367933a8532ee6ff8d63537de4f1177af4bff9f3e829baf7331f595bb24/attrs-25.3.0.tar.gz"
    sha256 "75d7cefc7fb576747b2c81b4442d4d4a1ce0900973527c011d1030fd3bf4af1b"
  end

  resource "colorlog" do
    url "https://files.pythonhosted.org/packages/d3/7a/359f4d5df2353f26172b3cc39ea32daa39af8de522205f512f458923e677/colorlog-6.9.0.tar.gz"
    sha256 "bfba54a1b93b94f54e1f4fe48395725a3d92fd2a4af702f6bd70946bdc0c6ac2"
  end

  resource "dependency-groups" do
    url "https://files.pythonhosted.org/packages/b4/57/cd53c3e335eafbb0894449af078e2b71db47e9939ce2b45013e5a9fe89b7/dependency_groups-1.3.0.tar.gz"
    sha256 "5b9751d5d98fbd6dfd038a560a69c8382e41afcbf7ffdbcc28a2a3f85498830f"
  end

  resource "distlib" do
    url "https://files.pythonhosted.org/packages/0d/dd/1bec4c5ddb504ca60fc29472f3d27e8d4da1257a854e1d96742f15c1d02d/distlib-0.3.9.tar.gz"
    sha256 "a60f20dea646b8a33f3e7772f74dc0b2d0772d2837ee1342a00645c81edf9403"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/0a/10/c23352565a6544bdc5353e0b15fc1c563352101f30e24bf500207a54df9a/filelock-3.18.0.tar.gz"
    sha256 "adbc88eabb99d2fec8c9c1b229b171f18afa655400173ddc653d5d01501fb9f2"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/a1/d4/1fc4078c65507b51b96ca8f8c3ba19e6a61c8253c72794544580a7b6c24d/packaging-25.0.tar.gz"
    sha256 "d443872c98d677bf60f6a1f2f8c1cb748e8fe762d2bf9d3148b5599295b0fc4f"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/b6/2d/7d512a3913d60623e7eb945c6d1b4f0bddf1d0b7ada5225274c87e5b53d1/platformdirs-4.3.7.tar.gz"
    sha256 "eb437d586b6a0986388f0d6f74aa0cde27b48d0e3d66843640bfb6bdcdb6e351"
  end

  resource "virtualenv" do
    url "https://files.pythonhosted.org/packages/38/e0/633e369b91bbc664df47dcb5454b6c7cf441e8f5b9d0c250ce9f0546401e/virtualenv-20.30.0.tar.gz"
    sha256 "800863162bcaa5450a6e4d721049730e7f2dae07720e0902b0e4040bd6f9ada8"
  end

  def install
    virtualenv_install_with_resources
    (bin/"tox-to-nox").unlink

    generate_completions_from_executable(libexec/"bin/register-python-argcomplete", "nox",
                                         shell_parameter_format: :arg)
  end

  test do
    ENV["LC_ALL"] = "en_US.UTF-8"
    (testpath/"noxfile.py").write <<~PYTHON
      import nox

      @nox.session
      def tests(session):
          session.install("pytest")
          session.run("pytest")
    PYTHON
    (testpath/"test_trivial.py").write <<~PYTHON
      def test_trivial():
          assert True
    PYTHON
    assert_match "usage", shell_output("#{bin}/nox --help")
    assert_match "Sessions defined in #{testpath}/noxfile.py", shell_output("#{bin}/nox --list-sessions")
  end
end
