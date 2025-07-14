class Apprise < Formula
  include Language::Python::Virtualenv

  desc "Send notifications from the command-line to popular notification services"
  homepage "https://pypi.org/project/apprise/"
  url "https://files.pythonhosted.org/packages/f8/1e/fe19c88c3e1ff96f4ea757bae9f6350060ac28be523507053347aa5d67db/apprise-1.9.3.tar.gz"
  sha256 "f583667ea35b8899cd46318c6cb26f0faf6a4605b119174c2523a012590c65a6"
  license "BSD-3-Clause"
  revision 2

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "a7c82a682ecf103d6137e6b334e453d28d461720352621506b88b54e082a060f"
    sha256 cellar: :any,                 arm64_sonoma:  "a65aff91277ab155606aa7cfc1eef89cfec14ff4fa847d15b4670b1e59d47ddc"
    sha256 cellar: :any,                 arm64_ventura: "6310cc3947bf9179df035378bd5f1c1c453ffb6f635da2efc0a93092124d7531"
    sha256 cellar: :any,                 sonoma:        "bb8363ad02d2ca2e75496ab5833a9d45a85d0b8eda746e3ad87a17ccf39f8609"
    sha256 cellar: :any,                 ventura:       "e262256143f9b0bce8c3804444944b382f61602fe655744500cd0433e6b3924e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fa3b052f8c8db8cc749b325bfa1df6b58bcc38ce995b7e3ac0d46062035a65e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fd4db6e05c3f60e449e0697a7d987e2399fb6abe5d1226abb3a022508951ba97"
  end

  depends_on "certifi"
  depends_on "libyaml"
  depends_on "python@3.13"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/e4/33/89c2ced2b67d1c2a61c19c6751aa8902d46ce3dacb23600a283619f5a12d/charset_normalizer-3.4.2.tar.gz"
    sha256 "5baececa9ecba31eff645232d59845c07aa030f0c81ee70184a90d35099a0e63"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/60/6c/8ca2efa64cf75a977a0d7fac081354553ebe483345c734fb6b6515d96bbc/click-8.2.1.tar.gz"
    sha256 "27c491cc05d968d271d5a1db13e3b5a184636d9d930f148c50b038f0d0646202"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f1/70/7703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7d/idna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "markdown" do
    url "https://files.pythonhosted.org/packages/db/7c/0738e5ff0adccd0b4e02c66d0446c03a3c557e02bb49b7c263d7ab56c57d/markdown-3.8.1.tar.gz"
    sha256 "a2e2f01cead4828ee74ecca9623045f62216aef2212a7685d6eb9163f590b8c1"
  end

  resource "oauthlib" do
    url "https://files.pythonhosted.org/packages/98/8a/6ea75ff7acf89f43afb157604429af4661a9840b1f2cece602b6a13c1893/oauthlib-3.3.0.tar.gz"
    sha256 "4e707cf88d7dfc22a8cce22ca736a2eef9967c1dd3845efc0703fc922353eeb2"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/54/ed/79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17/pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/e1/0a/929373653770d8a0d7ea76c37de6e41f11eb07559b103b1c02cafb3f7cf8/requests-2.32.4.tar.gz"
    sha256 "27d0316682c8a29834d3264820024b62a36942083d52caf2f14c0591336d3422"
  end

  resource "requests-oauthlib" do
    url "https://files.pythonhosted.org/packages/42/f2/05f29bc3913aea15eb670be136045bf5c5bbf4b99ecb839da9b422bb2c85/requests-oauthlib-2.0.0.tar.gz"
    sha256 "b3dffaebd884d8cd778494369603a9e7b58d29111bf6b41bdc2dcd87203af4e9"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/15/22/9ee70a2574a4f4599c47dd506532914ce044817c7752a79b6a51286319bc/urllib3-2.5.0.tar.gz"
    sha256 "3fc47733c7e419d4bc3f6b3dc2b4f890bb743906a30d56ba4a5bfa4bbff92760"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(bin/"apprise", shells: [:bash, :fish, :zsh], shell_parameter_format: :click)
  end

  test do
    # Setup a custom notifier that can be passed in as a plugin
    file = testpath/"brewtest_notifier.py"
    file.write <<~PYTHON
      from apprise.decorators import notify

      @notify(on="brewtest")
      def my_wrapper(body, title, *args, **kwargs):
        # A simple test - print to screen
        print("{}: {}".format(title, body))
    PYTHON

    charset = Array("A".."Z") + Array("a".."z") + Array(0..9)
    title = charset.sample(32).join
    body = charset.sample(256).join

    # Run the custom notifier and make sure the output matches the expected value
    assert_match "#{title}: #{body}",
      shell_output("#{bin}/apprise -P \"#{file}\" -t \"#{title}\" -b \"#{body}\" \"brewtest://\" 2>&1")
  end
end
