class Apprise < Formula
  desc "Send notifications from the command-line to popular notification services"
  homepage "https://pypi.org/project/apprise/"
  url "https://files.pythonhosted.org/packages/aa/99/f8e96a92f6385e6a5b38f454743dfa8a3610a9a0b4272df066c9aca97d72/apprise-1.7.2.tar.gz"
  sha256 "09e159b29008e6c8e93d7ffc3c15d419c0bbae41620405f8f2d3432b72a2e9bf"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3c8ac88640e2fe7f41c75861117330e387eff1863b5b9c7b29cf853bab2aa511"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "52ace3d76901afc72cc634ffe956c7a8c31b58c8f8383a38b693e63b0b378e74"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "62711ceb660ddd87fba25d61709d5ec944dcea13ad76ce5470a3556fe50cc90d"
    sha256 cellar: :any_skip_relocation, sonoma:         "e9dc6bb41abfa38408e50f432e9f41704e1795b362ab33b8d8057c0528abfc1a"
    sha256 cellar: :any_skip_relocation, ventura:        "cde663f69134d76fc46ca6e4751189d56030e11f82d0eda721dc4ab60a3b5930"
    sha256 cellar: :any_skip_relocation, monterey:       "ba0127910d3044d567b62f35a92247107b8015aca9b36619937b31a9ecfbb285"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f977a7d663ff7d03f1969925215a0d20f61eeb93da6ed388bf1bc6c58f7bea90"
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
