class Apprise < Formula
  desc "Send notifications from the command-line to popular notification services"
  homepage "https://pypi.org/project/apprise/"
  url "https://files.pythonhosted.org/packages/25/0c/519f0c8ca5d236c0a863fa9427937e013a0f9d534f8163ea1b69e9774b15/apprise-1.7.1.tar.gz"
  sha256 "8d439d08550470524425dedee4bc8a72766c216c218f3772c37404eb2fd86e5a"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "69274bcb4fafe866025cf0b8e446f8ed4ef23f67157870e1c0dbfaf0e4b5734a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3c12a7afaff520c1304d4a93f88fa3bce81643734f91030f8002c446d1afcf80"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f45ad5011e78e997ff7482746156adf4f8efb81465de336a5449bfebc30b9b96"
    sha256 cellar: :any_skip_relocation, sonoma:         "021286181d537fc2eb4c3ae3bec67edbe6cdfa21186159cdf990cbbc8fd8b132"
    sha256 cellar: :any_skip_relocation, ventura:        "582d989ee8ddd9cd231e8da735c0cad7840d2de5501b07a5acf1b87ececb74c9"
    sha256 cellar: :any_skip_relocation, monterey:       "c4ed5e2b0e7ff0ed2ed9485cb79e996234f1a36b6e54898a804b4ac7ced7cdb1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6c5d00522d9fe5b52a45e44ab5fa76cdfc4eca1b1a093b8b0c29fff55a9f6b65"
  end

  depends_on "python-setuptools" => :build
  depends_on "python-click"
  depends_on "python-markdown"
  depends_on "python-requests-oauthlib"
  depends_on "python@3.12"
  depends_on "pyyaml"

  def python3
    "python3.12"
  end

  def install
    system python3, "-m", "pip", "install", *std_pip_args, "."
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
