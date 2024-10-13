class MongoOrchestration < Formula
  include Language::Python::Virtualenv

  desc "REST API to manage MongoDB configurations on a single host"
  homepage "https://github.com/10gen/mongo-orchestration"
  url "https://files.pythonhosted.org/packages/f1/c6/3ccc6baa1693168052dff0a96450ac64ea738249c96d890c12c48e4b76a6/mongo_orchestration-0.9.0.tar.gz"
  sha256 "fcf3b644d946794218672f94ea63cea4de1d7a3c29c60bacae507bb64c147134"
  license "Apache-2.0"
  head "https://github.com/10gen/mongo-orchestration.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e72090a591082c708896c0a532b0766ed57df7a15a5a6fc6232724616f22d5ce"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0a8716d85b80f661330d4157c71ed5824d88073c9517e0987aa9beeaffa97c0c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f9cc085707934fc7eea5468d81f9be3070951b7c25b7875ee8cf5be21acdf39b"
    sha256 cellar: :any_skip_relocation, sonoma:        "21b9ad5e54e36b5ca36db95afc8094851758c7b42d1682129f03abb2075ac782"
    sha256 cellar: :any_skip_relocation, ventura:       "603da886e1419f68ca7d7016fe0cbdb6903cec0f25481f8bb88ff2c7c7f2eae6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d86b5a5852b44b306486edaa93781de3cd18120d6470e37809900411449a7c9a"
  end

  depends_on "certifi"
  depends_on "python@3.13"

  resource "bottle" do
    url "https://files.pythonhosted.org/packages/1b/fb/97839b95c2a2ea1ca91877a846988f90f4ca16ee42c0bb79e079171c0c06/bottle-0.13.2.tar.gz"
    sha256 "e53803b9d298c7d343d00ba7d27b0059415f04b9f6f40b8d58b5bf914ba9d348"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/f2/4f/e1808dc01273379acc506d18f1504eb2d299bd4131743b9fc54d7be4df1e/charset_normalizer-3.4.0.tar.gz"
    sha256 "223217c3d4f82c3ac5e29032b3f1c2eb0fb591b72161f86d93f5719079dae93e"
  end

  resource "cheroot" do
    url "https://files.pythonhosted.org/packages/63/e2/f85981a51281bd30525bf664309332faa7c81782bb49e331af603421dbd1/cheroot-10.0.1.tar.gz"
    sha256 "e0b82f797658d26b8613ec8eb563c3b08e6bd6a7921e9d5089bd1175ad1b1740"
  end

  resource "dnspython" do
    url "https://files.pythonhosted.org/packages/b5/4a/263763cb2ba3816dd94b08ad3a33d5fdae34ecb856678773cc40a3605829/dnspython-2.7.0.tar.gz"
    sha256 "ce9c432eda0dc91cf618a5cedf1a4e142651196bbcd2c80e89ed5a907e5cfaf1"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f1/70/7703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7d/idna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "jaraco-functools" do
    url "https://files.pythonhosted.org/packages/ab/23/9894b3df5d0a6eb44611c36aec777823fc2e07740dabbd0b810e19594013/jaraco_functools-4.1.0.tar.gz"
    sha256 "70f7e0e2ae076498e212562325e805204fc092d7b4c17e0e86c959e249701a9d"
  end

  resource "more-itertools" do
    url "https://files.pythonhosted.org/packages/51/78/65922308c4248e0eb08ebcbe67c95d48615cc6f27854b6f2e57143e9178f/more-itertools-10.5.0.tar.gz"
    sha256 "5482bfef7849c25dc3c6dd53a6173ae4795da2a41a80faea6700d9f5846c5da6"
  end

  resource "pymongo" do
    url "https://files.pythonhosted.org/packages/1a/35/b62a3139f908c68b69aac6a6a3f8cc146869de0a7929b994600e2c587c77/pymongo-4.10.1.tar.gz"
    sha256 "a9de02be53b6bb98efe0b9eda84ffa1ec027fcb23a2de62c4f941d9a2f2f3330"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/63/70/2bf7780ad2d390a8d301ad0b550f1581eadbd9a20f896afe06353c2a2913/requests-2.32.3.tar.gz"
    sha256 "55365417734eb18255590a9ff9eb97e9e1da868d4ccd6402399eaf68af20a760"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/ed/63/22ba4ebfe7430b76388e7cd448d5478814d3032121827c12a2cc287e2260/urllib3-2.2.3.tar.gz"
    sha256 "e7d814a81dad81e6caf2ec9fdedb284ecc9c73076b62654547cc64ccdcae26e9"
  end

  def install
    virtualenv_install_with_resources
  end

  service do
    run [opt_bin/"mongo-orchestration", "-b", "127.0.0.1", "-p", "8889", "--no-fork", "start"]
    require_root true
  end

  test do
    system bin/"mongo-orchestration", "-h"
  end
end
