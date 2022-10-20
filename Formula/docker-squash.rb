class DockerSquash < Formula
  include Language::Python::Virtualenv

  desc "Docker image squashing tool"
  homepage "https://github.com/goldmann/docker-squash"
  url "https://files.pythonhosted.org/packages/30/9b/efe399a60c67f6502c640b9c2993a9efc40a9fcfc616f9507bdcfc50dab4/docker-squash-1.0.9.tar.gz"
  sha256 "ed8a8a0f715aa6179e64c54a22dba7f2de6f80349041ebe797e6bb0f3b444962"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "34ffa00ff0b4281be8e3045b16540c16d5b2641b1db0a439683fad9ed9a0000a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "34ffa00ff0b4281be8e3045b16540c16d5b2641b1db0a439683fad9ed9a0000a"
    sha256 cellar: :any_skip_relocation, monterey:       "9e71ec67027c51c69ca0f4c14ce625f903459ba0dc1b8b3d3c567231399932b5"
    sha256 cellar: :any_skip_relocation, big_sur:        "9e71ec67027c51c69ca0f4c14ce625f903459ba0dc1b8b3d3c567231399932b5"
    sha256 cellar: :any_skip_relocation, catalina:       "9e71ec67027c51c69ca0f4c14ce625f903459ba0dc1b8b3d3c567231399932b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "abf9c555713d040f08bbe871532b365e87004eac8c6b55268708d378f0504ae3"
  end

  depends_on "python@3.10"
  depends_on "six"

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/6c/ae/d26450834f0acc9e3d1f74508da6df1551ceab6c2ce0766a593362d6d57f/certifi-2021.10.8.tar.gz"
    sha256 "78884e7c1d4b00ce3cea67b44566851c4343c120abd683433ce934a68ea58872"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/2f/39/5d8ff929409113e9ff402e405a7c7880ab1fa6f118a4ab72443976a01711/charset-normalizer-2.0.8.tar.gz"
    sha256 "735e240d9a8506778cd7a453d97e817e536bb1fc29f4f6961ce297b9c7a917b0"
  end

  resource "docker" do
    url "https://files.pythonhosted.org/packages/ab/d2/45ea0ee13c6cffac96c32ac36db0299932447a736660537ec31ec3a6d877/docker-5.0.3.tar.gz"
    sha256 "d916a26b62970e7c2f554110ed6af04c7ccff8e9f81ad17d0d40c75637e227fb"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/62/08/e3fc7c8161090f742f504f40b1bccbfc544d4a4e09eb774bf40aafce5436/idna-3.3.tar.gz"
    sha256 "9d643ff0a55b762d5cdb124b8eaa99c66322e2157b69160bc32796e824360e6d"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/e7/01/3569e0b535fb2e4a6c384bdbed00c55b9d78b5084e0fb7f4d0bf523d7670/requests-2.26.0.tar.gz"
    sha256 "b8aa58f8cf793ffd8782d3d8cb19e66ef36f7aba4353eec859e74678b01b07a7"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/80/be/3ee43b6c5757cabea19e75b8f46eaf05a2f5144107d7db48c7cf3a864f73/urllib3-1.26.7.tar.gz"
    sha256 "4987c65554f7a2dbf30c18fd48778ef124af6fab771a377103da0585e2336ece"
  end

  resource "websocket-client" do
    url "https://files.pythonhosted.org/packages/4e/8f/b5c45af5a1def38b07c09a616be932ad49c35ebdc5e3cbf93966d7ed9750/websocket-client-1.2.1.tar.gz"
    sha256 "8dfb715d8a992f5712fff8c843adae94e22b22a99b2c5e6b0ec4a1a981cc4e0d"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    ENV["DOCKER_HOST"] = "does-not-exist:1234"
    output = shell_output("#{bin}/docker-squash not_an_image 2>&1", 1)
    assert_match "Could not create Docker client", output
  end
end
