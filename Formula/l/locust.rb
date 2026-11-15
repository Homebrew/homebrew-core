class Locust < Formula
  include Language::Python::Virtualenv

  desc "Scalable user load testing tool written in Python"
  homepage "https://locust.io/"
  url "https://files.pythonhosted.org/packages/d2/17/1099f80db4462e93c56619f3aba0c629ea01b08fd143181c2ecfa128f9bd/locust-2.47.0.tar.gz"
  sha256 "70ffe28cdb7a3224a4efb60b31d585c26343d5679fec8d5b18017ffb6893b423"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "348e3b6cf75bb978c50dba18e09b5bc210e4bf7327f8af8638d5ebfd98b5be6b"
    sha256 cellar: :any, arm64_tahoe:       "07b2fa9b1c33e540e7f0f120b4dfb1ceef34ede26266d3d4bd564e98fe162287"
    sha256 cellar: :any, arm64_sequoia:     "af99f1d687e55fb7a186ea2e7ae667f54310f3d4d9301a24113443c3e1df4b8b"
    sha256 cellar: :any, arm64_linux:       "3514905ef35c89aec113dfd3aaf30f3264692a6f392b3ef85d12f3729b5e47e4"
    sha256 cellar: :any, x86_64_linux:      "9bb50eb14753c1bbfe9c9c19eb5658c5e41c1d1df625297280e532d62de022e9"
  end

  depends_on "cmake" => :build # for pyzmq
  depends_on "ninja" => :build # for pyzmq
  depends_on "rust" => :build # for bidict
  depends_on "certifi"
  depends_on "python@3.15"
  depends_on "zeromq"

  pypi_packages exclude_packages: "certifi"

  resource "bidict" do
    url "https://files.pythonhosted.org/packages/a8/f2/8d2dd8276ca05e1f5157b6a0d34efb2f585f47a0fbed61e8aad04b221f0b/bidict-0.24.1.tar.gz"
    sha256 "4dca6c17f0b01700e9f24359daa5ebabf7be022d99f4cb2a257b6af2a5076c88"
  end

  resource "blinker" do
    url "https://files.pythonhosted.org/packages/21/28/9b3f50ce0e048515135495f198351908d99540d69bfdc8c1d15b73dc55ce/blinker-1.9.0.tar.gz"
    sha256 "b4ce2265a7abece45e7cc896e98dbebe6cead56bcf805a3d23136d145f5445bf"
  end

  resource "brotli" do
    url "https://files.pythonhosted.org/packages/cf/81/1546c983678a9b4e77cb4718eaedd1b2caf24a6cdbf1eb8775938d22aff7/brotli-1.2.1.tar.gz"
    sha256 "02b2f7b5a83485efe448a44ddf7983def05c3bb1dcf917d4f7154070260e13de"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/33/1c/f41d4e74c28ab327ff3acd36053f7ea506c55872d7a90b0fa71aa3ab0c89/charset_normalizer-3.5.2.tar.gz"
    sha256 "39de2a259fc954455c57274dc94c79d5842774e1247a016aff30bc0efed0f4ef"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/c7/0e/7fa0ef50764b67090eca4114772a2abf8b6148198475e54c660b97caeee6/click-8.5.0.tar.gz"
    sha256 "ba0d2089de75ea0310e2dde03160e6ca10009947fb95a182f9b54021bb272e34"
  end

  resource "configargparse" do
    url "https://files.pythonhosted.org/packages/5d/ed/33c0ba7f0b5be384ff8a2101ce77728f219e816b2104819f1651477e1ad5/configargparse-1.8.0.tar.gz"
    sha256 "22a417f4d7b00149f0af82ef7c491f8ecc4b1d5454633fd319b386f5eb806f92"
  end

  resource "flask" do
    url "https://files.pythonhosted.org/packages/26/00/35d85dcce6c57fdc871f3867d465d780f302a175ea360f62533f12b27e2b/flask-3.1.3.tar.gz"
    sha256 "0ef0e52b8a9cd932855379197dd8f94047b359ca0a78695144304cb45f87c9eb"
  end

  resource "flask-cors" do
    url "https://files.pythonhosted.org/packages/47/03/4e464a50860f9adf08b5c1d3479cb8ea1f12af2aa69535c7042c6e628135/flask_cors-6.0.5.tar.gz"
    sha256 "30c5031552cd59f620ac0c8211dac45b345d3b2df310e7721879e4f46ef9c601"
  end

  resource "flask-login" do
    url "https://files.pythonhosted.org/packages/c3/6e/2f4e13e373bb49e68c02c51ceadd22d172715a06716f9299d9df01b6ddb2/Flask-Login-0.6.3.tar.gz"
    sha256 "5e23d14a607ef12806c699590b89d0f0e0d67baeec599d75947bf9c147330333"
  end

  resource "gevent" do
    url "https://files.pythonhosted.org/packages/2b/ac/dd3137ae695aef399373088c84c66398f3eac597fba542f0a22280bc21d6/gevent-26.9.0.tar.gz"
    sha256 "4dd4703d71737a456c1c9df5cd43a82934e5b10c87549caa02495f487d1ef0b1"
  end

  resource "geventhttpclient" do
    url "https://files.pythonhosted.org/packages/5f/e4/2835286913c2901f3d2246843deb8d99ba33de2b3a2ef8c4bb4c1a99f314/geventhttpclient-2.6.1.tar.gz"
    sha256 "b15f0b0b959e75f4b8d97f3652e07db6d1050308027e1081eecddfbaa8412c92"
  end

  resource "greenlet" do
    url "https://files.pythonhosted.org/packages/3e/6e/0091f175ccd02b02bc8811bbcbcc6ac2e980be116e3b2f7a736ca322bf84/greenlet-3.5.6.tar.gz"
    sha256 "8e67c43bdfc88d5fee6db0d3e40175b362fc95fb85f0412d233b9b203c53a575"
  end

  resource "h11" do
    url "https://files.pythonhosted.org/packages/01/ee/02a2c011bdab74c6fb3c75474d40b3052059d95df7e73351460c8588d963/h11-0.16.0.tar.gz"
    sha256 "4e35b956cf45792e4caa5885e69fba00bdbc6ffafbfa020300e549b208ee5ff1"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f5/08/8eea9d4b8302028f3abb2c0813953f7aec26d33b7a8960ed760e65ff29fa/idna-3.20.tar.gz"
    sha256 "a7db850025b95ded1eae8a46181a1a6c56c92c96f0e2b005d9ff8dc0210cab44"
  end

  resource "iniconfig" do
    url "https://files.pythonhosted.org/packages/01/e1/2069291243c926a2ff1cd706c7f3eeb9b62144bf60f77c9fb9ff2fb26bd3/iniconfig-2.3.1.tar.gz"
    sha256 "67f4b9c50da0dedf52af349e7749a80a9057a5031199791b906c3bb3ae878960"
  end

  resource "itsdangerous" do
    url "https://files.pythonhosted.org/packages/9c/cb/8ac0172223afbccb63986cc25049b154ecfb5e85932587206f42317be31d/itsdangerous-2.2.0.tar.gz"
    sha256 "e0050c0b7da1eea53ffaf149c0cfbb5c6e2e2b69c4bef22c81fa6eb73e5f6173"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/df/bf/f7da0350254c0ed7c72f3e33cef02e048281fec7ecec5f032d4aac52226b/jinja2-3.1.6.tar.gz"
    sha256 "0137fb05990d35f1275a587e9aee6d56da821fc83491a0fb838183be43f66d6d"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/38/9b/e422a865e1d5d57d0e509b4e0bf1c1a70a7f6382c29a5aa428df994c8bc8/markupsafe-3.0.4.tar.gz"
    sha256 "2e9ad7dd851bf45fab9f75cbff4cb493fee9979e8d8c7c9c3ee119022518edd6"
  end

  resource "msgpack" do
    url "https://files.pythonhosted.org/packages/0a/e7/bb605a7bab2d8425a64b3fa762b39dc1bf1c7e3f11ba6fb5413d6db0ff8c/msgpack-1.2.3.tar.gz"
    sha256 "32edb81a2b5eb7cd7c9d941b2bfbbb082fd2cd09e0e725930316af6b708db186"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/7d/fa/3944b40b07da9ce895c0e6303a5ab7d53da063554f534556b134a54d6093/packaging-26.3.tar.gz"
    sha256 "94edc256424af38762eb31306eed28beb9f0efc50a8837492c9d6fd6004aed79"
  end

  resource "pluggy" do
    url "https://files.pythonhosted.org/packages/bf/db/7fc19e6f2dc92a966727031389fc2e08b558f0f25eb7403c1119ad4713cd/pluggy-1.7.0.tar.gz"
    sha256 "d1eaa46ebb595891b860ab086b4d09c8588af65ebd4361b8e8f4bb8920b90ba8"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/aa/c6/d1ddf4abb55e93cebc4f2ed8b5d6dbad109ecb8d63748dd2b20ab5e57ebe/psutil-7.2.2.tar.gz"
    sha256 "0746f5f8d406af344fd547f1c8daa5f5c33dbc293bb8d6a16d80b4bb88f59372"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/49/2e/ced460408999b33da6b31b0021b0f37d329e202d4169aeb164493778f25b/pygments-2.21.0.tar.gz"
    sha256 "610ca751c9bc2492b38eb9a38a7fbc93edbbb2d7182edaf34e66ae493dee5c8c"
  end

  resource "pytest" do
    url "https://files.pythonhosted.org/packages/e4/47/b9efed96c114afcfa3c9d3fe98a76a1d14c74a9e266d397cf6eb64be5e01/pytest-9.1.1.tar.gz"
    sha256 "1088fbde8f2b49d95a549a195707afa7a76a3ce9bcadc26b6d71f0ffda5fe313"
  end

  resource "python-engineio" do
    url "https://files.pythonhosted.org/packages/fc/65/f8bae11b228647e2e2f45b63dec7448efaddb7cb51f529de1fdba69e63b5/python_engineio-4.14.0.tar.gz"
    sha256 "eaa1e386baf9c2c7959eef7f9d9165c5ea910c5b392f5316e78d29ed073cb43d"
  end

  resource "python-socketio" do
    url "https://files.pythonhosted.org/packages/b9/04/8647675c93b5e74a3daa41a2a03930bac0cbdcfcf307900f0441ae6550ba/python_socketio-5.17.0.tar.gz"
    sha256 "c3bbfc4937dcfea7c4d1b182afa94d4a30335d153987e8f2078b344beacf95a0"
  end

  resource "pyzmq" do
    url "https://files.pythonhosted.org/packages/e7/8d/5b3d5631c2f4b4b8862f64cd0c9eb777b5710eeb5125b4be8dd0a200a4c0/pyzmq-27.2.0.tar.gz"
    sha256 "54d4259d1bfae24ecdb5ca79f7acc2eac6c286a02d6a0ae617797cb45f0726d3"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/ac/c3/e2a2b89f2d3e2179abd6d00ebd70bff6273f37fb3e0cc209f48b39d00cbf/requests-2.34.2.tar.gz"
    sha256 "f288924cae4e29463698d6d60bc6a4da69c89185ad1e0bcc4104f584e960b9ed"
  end

  resource "simple-websocket" do
    url "https://files.pythonhosted.org/packages/b0/d4/bfa032f961103eba93de583b161f0e6a5b63cebb8f2c7d0c6e6efe1e3d2e/simple_websocket-1.1.0.tar.gz"
    sha256 "7939234e7aa067c534abdab3a9ed933ec9ce4691b0713c78acb195560aa52ae4"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/e3/05/b17359e1cefb4f909b5e40b1b90a496d987258916dbbf88e842c729f510e/urllib3-2.8.0.tar.gz"
    sha256 "63bf2ead4c879426ebf22ef2a781eeb4aa3b4ae798a0435506f8687fd5bb9b63"
  end

  resource "websocket-client" do
    url "https://files.pythonhosted.org/packages/d8/cb/a5abcc2891249f393827c650c6296660ce40374ac22d99ab9aea41f9d2a2/websocket_client-1.9.2.tar.gz"
    sha256 "0fcb57545848be86992e128218fd96dd87a6769ffdb1a968dff79632b85604d0"
  end

  resource "werkzeug" do
    url "https://files.pythonhosted.org/packages/a4/34/4dd12fc8bb7d61c91467ec3efe415ffa7d5456f799954b40c5bbaeae470e/werkzeug-3.1.9.tar.gz"
    sha256 "55ca7c70a75689be937aa27f8ff4b018f06ff4838fc73045560bf0f5a1291060"
  end

  resource "wsproto" do
    url "https://files.pythonhosted.org/packages/c7/79/12135bdf8b9c9367b8701c2c19a14c913c120b882d50b014ca0d38083c2c/wsproto-1.3.2.tar.gz"
    sha256 "b86885dcf294e15204919950f666e06ffc6c7c114ca900b060d6e16293528294"
  end

  resource "zope-event" do
    url "https://files.pythonhosted.org/packages/93/41/faa10af34d48d9cd6fa0249a1162943ad84a9590bd1a06939981e6640416/zope_event-6.2.tar.gz"
    sha256 "b97d5d6327067ee6b9dfcbdf606ade9ade70991e19c162e808ea39e5fcf0f8d3"
  end

  resource "zope-interface" do
    url "https://files.pythonhosted.org/packages/de/ff/a1f0021a26033da0df223fd05a7455d6d2881b67daf2c6dc897b4fe0a427/zope_interface-8.7.tar.gz"
    sha256 "0b47b62e8d0d99b24bcdd32f4f2120425e5019c3bee2ad69a0e1d75737487a96"
  end

  deny_network_access! :test

  def install
    # skip frontend build
    ENV["SKIP_PRE_BUILD"] = "true"

    virtualenv_install_with_resources
  end

  test do
    (testpath/"locustfile.py").write <<~PYTHON
      from pathlib import Path
      from locust import User, constant, task

      class HelloWorldUser(User):
          wait_time = constant(0.1)

          @task
          def hello_world(self):
              Path("result.txt").write_text("Hello from Locust!")
    PYTHON

    ENV["LOCUST_LOCUSTFILE"] = testpath/"locustfile.py"
    ENV["LOCUST_USERS"] = "2"

    system bin/"locust", "--headless", "--run-time", "3s"
    assert_equal "Hello from Locust!", (testpath/"result.txt").read
  end
end
