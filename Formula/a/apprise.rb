class Apprise < Formula
  include Language::Python::Virtualenv

  desc "Send notifications from the command-line to popular notification services"
  homepage "https://pypi.org/project/apprise/"
  url "https://files.pythonhosted.org/packages/51/f9/bda66afaf393f6914f4d6c035964936cadd98ee1fef44e4e77cba3b5828c/apprise-1.9.4.tar.gz"
  sha256 "483122aee19a89a7b075ecd48ef11ae37d79744f7aeb450bcf985a9a6c28c988"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c111e79a9641a48882a84c823b0bfaf3963bad0053c17ba2b4f62e1fa09c2099"
    sha256 cellar: :any,                 arm64_sequoia: "7574c998a62e275d358b6f498fed1791c9f82196087626515ce96427914278c6"
    sha256 cellar: :any,                 arm64_sonoma:  "0b646984e8f96d97a4e6e74e0702fe4bccc31155bdfc343441f4ca18fd834a18"
    sha256 cellar: :any,                 arm64_ventura: "bcdfedc981695fd3c5c11c6aad94b1bf153c1bb508ed081da6185516447321e8"
    sha256 cellar: :any,                 sonoma:        "9c26139df8e1c73d83283ad38e3b3ec838a2af06664fc54960f558bb27a5e05b"
    sha256 cellar: :any,                 ventura:       "d6c7ac83d80f81844d06038ec8d23ee50ddb99a5e2c9a4f69486a0dc48106dea"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b6d4a7086a88b3242114eb1a1d510adcfab8f7dcffa02904f8152637806f6dc5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8fdbcda12d00a1582cb4524daf274c6315e0edda2081a22c98fdf2e49248c1a7"
  end

  depends_on "certifi"
  depends_on "libyaml"
  depends_on "python@3.13"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/e4/33/89c2ced2b67d1c2a61c19c6751aa8902d46ce3dacb23600a283619f5a12d/charset_normalizer-3.4.2.tar.gz"
    sha256 "5baececa9ecba31eff645232d59845c07aa030f0c81ee70184a90d35099a0e63"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/e9/87/105111999772ec9730e3d4d910c723ea9763ece2ec441533a5cea1e87e3c/click-8.2.2.tar.gz"
    sha256 "068616e6ef9705a07b6db727cb9c248f4eb9dae437a30239f56fa94b18b852ef"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f1/70/7703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7d/idna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "markdown" do
    url "https://files.pythonhosted.org/packages/d7/c2/4ab49206c17f75cb08d6311171f2d65798988db4360c4d1485bd0eedd67c/markdown-3.8.2.tar.gz"
    sha256 "247b9a70dd12e27f67431ce62523e675b866d254f900c4fe75ce3dda62237c45"
  end

  resource "oauthlib" do
    url "https://files.pythonhosted.org/packages/0b/5f/19930f824ffeb0ad4372da4812c50edbd1434f678c90c2733e1188edfc63/oauthlib-3.3.1.tar.gz"
    sha256 "0f0f8aa759826a193cf66c12ea1af1637f87b9b4622d46e866952bb022e538c9"
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

    generate_completions_from_executable(bin/"apprise", shell_parameter_format: :click)
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
