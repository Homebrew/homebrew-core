class Apprise < Formula
  include Language::Python::Virtualenv

  desc "Send notifications from the command-line to popular notification services"
  homepage "https://pypi.org/project/apprise/"
  url "https://files.pythonhosted.org/packages/2f/74/9c16829d3e7e45ce7daf1b704687fa4fde7ea00d72eafe8de18c72bf5995/apprise-1.10.0.tar.gz"
  sha256 "b768f32d99e45ed5f4c3eef1f67903e803c97f97ba61a531a5d0a45d40df90a8"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "368d80d8324136215dc957ddf7c55ae511664f38b455d32c05302575fc0a83a6"
    sha256 cellar: :any,                 arm64_sequoia: "67872e6dba410069e6702456d780456a312f5551f4f0fe8da0d00d732bc343a9"
    sha256 cellar: :any,                 arm64_sonoma:  "3828587acc342d928fddae6d28a7bf234093b5788ac2ccfa523325751212ba64"
    sha256 cellar: :any,                 sonoma:        "fec3c78446eaf6d7f53b6590eb598e9f6ab8849b45672c9b5a24afa57cadd0e3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eeec860adf335460b845a80a560c8b4292b3f2ab038a0d435fc83cd14a0b255d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e1f19f989ded5e9b3c8ffb1a56229d9cbe73fd7e46eb5314c17657a9f5ab0efa"
  end

  depends_on "certifi"
  depends_on "libyaml"
  depends_on "python@3.14"

  pypi_packages exclude_packages: "certifi"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/e7/a1/67fe25fac3c7642725500a3f6cfe5821ad557c3abb11c9d20d12c7008d3e/charset_normalizer-3.4.7.tar.gz"
    sha256 "ae89db9e5f98a11a4bf50407d4363e7b09b31e55bc117b4f7d80aab97ba009e5"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/bb/63/f9e1ea081ce35720d8b92acde70daaedace594dc93b693c869e0d5910718/click-8.3.3.tar.gz"
    sha256 "398329ad4837b2ff7cbe1dd166a4c0f8900c3ca3a218de04466f38f6497f18a2"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/ce/cc/762dfb036166873f0059f3b7de4565e1b5bc3d6f28a414c13da27e442f99/idna-3.13.tar.gz"
    sha256 "585ea8fe5d69b9181ec1afba340451fba6ba764af97026f92a91d4eef164a242"
  end

  resource "markdown" do
    url "https://files.pythonhosted.org/packages/2b/f4/69fa6ed85ae003c2378ffa8f6d2e3234662abd02c10d216c0ba96081a238/markdown-3.10.2.tar.gz"
    sha256 "994d51325d25ad8aa7ce4ebaec003febcce822c3f8c911e3b17c52f7f589f950"
  end

  resource "oauthlib" do
    url "https://files.pythonhosted.org/packages/0b/5f/19930f824ffeb0ad4372da4812c50edbd1434f678c90c2733e1188edfc63/oauthlib-3.3.1.tar.gz"
    sha256 "0f0f8aa759826a193cf66c12ea1af1637f87b9b4622d46e866952bb022e538c9"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/5f/a4/98b9c7c6428a668bf7e42ebb7c79d576a1c3c1e3ae2d47e674b468388871/requests-2.33.1.tar.gz"
    sha256 "18817f8c57c6263968bc123d237e3b8b08ac046f5456bd1e307ee8f4250d3517"
  end

  resource "requests-oauthlib" do
    url "https://files.pythonhosted.org/packages/42/f2/05f29bc3913aea15eb670be136045bf5c5bbf4b99ecb839da9b422bb2c85/requests-oauthlib-2.0.0.tar.gz"
    sha256 "b3dffaebd884d8cd778494369603a9e7b58d29111bf6b41bdc2dcd87203af4e9"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/c7/24/5f1b3bdffd70275f6661c76461e25f024d5a38a46f04aaca912426a2b1d3/urllib3-2.6.3.tar.gz"
    sha256 "1b62b6884944a57dbe321509ab94fd4d3b307075e0c2eae991ac71ee15ad38ed"
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
