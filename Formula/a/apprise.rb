class Apprise < Formula
  include Language::Python::Virtualenv

  desc "Send notifications from the command-line to popular notification services"
  homepage "https://pypi.org/project/apprise/"
  url "https://files.pythonhosted.org/packages/0a/08/dac0221615b78c97dfc031d5043d44084e23898e05e1a471c48e31e67e09/apprise-1.7.4.tar.gz"
  sha256 "ef5e830051140d4228a759c5bc2d6857bcc7f8664df3e44f30f64617ce0c7a73"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "7b86eb2fceaf4fb98eee022378ac2ddf18c76e49bd239e202aa24c2e5fc7c94a"
    sha256 cellar: :any,                 arm64_ventura:  "6bc4b901249c2d34babf261865ef723f9f056ed088799d35751bdced942539c1"
    sha256 cellar: :any,                 arm64_monterey: "95503904c28227d042c3328fcf69f250b3c1168e78f4f11fd2d210bd65c47541"
    sha256 cellar: :any,                 sonoma:         "e158b8bd8be413549e377d4193fec2d97afa167def2b05047ac9a90c0521feed"
    sha256 cellar: :any,                 ventura:        "33488ac66108a920860ba2a7eeda34fffbb956db86bdfb4a96dab2eba1ac6e13"
    sha256 cellar: :any,                 monterey:       "fd156203adbbfe82ac733df07520225089db94269dbc834c486e9fce88852d56"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "980655ce6d442249c7fb98b0ad1cb81bf0b80f2ef24e5828b59ed3d759fbf0f4"
  end

  depends_on "certifi"
  depends_on "libyaml"
  depends_on "python@3.12"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/63/09/c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8/charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/96/d3/f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5/click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/bf/3f/ea4b9117521a1e9c50344b909be7886dd00a519552724809bb1f486986c2/idna-3.6.tar.gz"
    sha256 "9ecdbbd083b06798ae1e86adcbfe8ab1479cf864e4ee30fe4e46a003d12491ca"
  end

  resource "markdown" do
    url "https://files.pythonhosted.org/packages/11/28/c5441a6642681d92de56063fa7984df56f783d3f1eba518dc3e7a253b606/Markdown-3.5.2.tar.gz"
    sha256 "e1ac7b3dc550ee80e602e71c1d168002f062e49f1b11e26a36264dafd4df2ef8"
  end

  resource "oauthlib" do
    url "https://files.pythonhosted.org/packages/6d/fa/fbf4001037904031639e6bfbfc02badfc7e12f137a8afa254df6c4c8a670/oauthlib-3.2.2.tar.gz"
    sha256 "9859c40929662bec5d64f34d01c99e093149682a3f38915dc0655d5a633dd918"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/cd/e5/af35f7ea75cf72f2cd079c95ee16797de7cd71f29ea7c68ae5ce7be1eda0/PyYAML-6.0.1.tar.gz"
    sha256 "bfdf460b1736c775f2ba9f6a92bca30bc2095067b8a9d77876d1fad6cc3b4a43"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "requests-oauthlib" do
    url "https://files.pythonhosted.org/packages/95/52/531ef197b426646f26b53815a7d2a67cb7a331ef098bb276db26a68ac49f/requests-oauthlib-1.3.1.tar.gz"
    sha256 "75beac4a47881eeb94d5ea5d6ad31ef88856affe2332b9aafb52c6452ccf0d7a"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/7a/50/7fd50a27caa0652cd4caf224aa87741ea41d3265ad13f010886167cfcc79/urllib3-2.2.1.tar.gz"
    sha256 "d0570876c61ab9e520d776c38acbbb5b05a776d3f9ff98a5c8fd5162a444cf19"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    # Setup a custom notifier that can be passed in as a plugin
    brewtest_notifier_file = "#{testpath}/brewtest_notifier.py"
    apprise_plugin_definition = <<~EOS
      from apprise.decorators import notify

      @notify(on="brewtest")
      def my_wrapper(body, title, *args, **kwargs):
        # A simple test - print to screen
        print("{}: {}".format(title, body))
    EOS

    File.write(brewtest_notifier_file, apprise_plugin_definition)

    charset = Array("A".."Z") + Array("a".."z") + Array(0..9)
    brewtest_notification_title = charset.sample(32).join
    brewtest_notification_body = charset.sample(256).join

    # Run the custom notifier and make sure the output matches the expected value
    assert_match \
      "#{brewtest_notification_title}: #{brewtest_notification_body}", \
      shell_output(
        "#{bin}/apprise" \
        + " " + %Q(-P "#{brewtest_notifier_file}") \
        + " " + %Q(-t "#{brewtest_notification_title}") \
        + " " + %Q(-b "#{brewtest_notification_body}") \
        + " " + '"brewtest://"' \
        + " " + "2>&1",
      )
  end
end
