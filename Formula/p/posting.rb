class Posting < Formula
  include Language::Python::Virtualenv

  desc "Modern API client that lives in your terminal"
  homepage "https://github.com/darrenburns/posting"
  url "https://files.pythonhosted.org/packages/57/c5/50f29f97c0d477b0bc70362230e195ef49e4776a5f719e8db8866a615d81/posting-2.6.0.tar.gz"
  sha256 "d4654399299b2d0d226c5ad806d452fe6a94931569609cb283f100052745bf91"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "104b4c64dbb8364e1b09952405db0c48bf5a901ef9b90681b05f6b5e3c9934f4"
    sha256 cellar: :any,                 arm64_sonoma:  "9b76d6af1d70bdbe77ed393853e29eca2c8f4893a6a82e1b91f30f3a699e4fb3"
    sha256 cellar: :any,                 arm64_ventura: "44848246f531e8800cd1eb38b11a81047b32ff9ce9d4b64735e5c6902852b98d"
    sha256 cellar: :any,                 sonoma:        "9170fd60a78cc6aba8081ba0492897dbfccacea60c16ae9c7c6aabf52a264a29"
    sha256 cellar: :any,                 ventura:       "4424415f29b6e9553eeabc773f7dd80e08e80dadca79e6998bdc5874235cf4c1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d22e0c1da88f01a742e41cd3ad3d16c303a5b1d76fd375c8bcd0e4e92b3fa4b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b4aaa8fbcfa8112aa69e36d8b10af8c88f1c12db9bffa4b983574d37d4c8095d"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  depends_on "brotli"
  depends_on "certifi"
  depends_on "libyaml"
  depends_on "python@3.13"
  depends_on "tree-sitter"

  resource "annotated-types" do
    url "https://files.pythonhosted.org/packages/ee/67/531ea369ba64dcff5ec9c3402f9f51bf748cec26dde048a2f973a4eea7f5/annotated_types-0.7.0.tar.gz"
    sha256 "aff07c09a53a08bc8cfccb9c85b05f1aa9a2a6f23728d790723543408344ce89"
  end

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/a3/73/199a98fc2dae33535d6b8e8e6ec01f8c1d76c9adb096c6b7d64823038cde/anyio-4.8.0.tar.gz"
    sha256 "1d9fe889df5212298c0c0723fa20479d1b94883a2df44bd3897aa91083316f7a"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/b9/2e/0090cbf739cee7d23781ad4b89a9894a41538e4fcf4c31dcdd705b78eb8b/click-8.1.8.tar.gz"
    sha256 "ed53c9d8990d83c2a27deae68e4ee337473f6330c040a31d4225c9574d16096a"
  end

  resource "click-default-group" do
    url "https://files.pythonhosted.org/packages/1d/ce/edb087fb53de63dad3b36408ca30368f438738098e668b78c87f93cd41df/click_default_group-1.2.4.tar.gz"
    sha256 "eb3f3c99ec0d456ca6cd2a7f08f7d4e91771bef51b01bdd9580cc6450fe1251e"
  end

  resource "h11" do
    url "https://files.pythonhosted.org/packages/f5/38/3af3d3633a34a3316095b39c8e8fb4853a28a536e55d347bd8d8e9a14b03/h11-0.14.0.tar.gz"
    sha256 "8f19fbbe99e72420ff35c00b27a34cb9937e902a8b810e2c88300c6f0a3b699d"
  end

  resource "httpcore" do
    url "https://files.pythonhosted.org/packages/6a/41/d7d0a89eb493922c37d343b607bc1b5da7f5be7e383740b4753ad8943e90/httpcore-1.0.7.tar.gz"
    sha256 "8551cb62a169ec7162ac7be8d4817d561f60e08eaa485234898414bb5a8a0b4c"
  end

  resource "httpx" do
    url "https://files.pythonhosted.org/packages/b1/df/48c586a5fe32a0f01324ee087459e112ebb7224f646c0b5023f5e79e9956/httpx-0.28.1.tar.gz"
    sha256 "75e98c5f16b0f35b567856f597f06ff2270a374470a5c2392242528e3e3e42fc"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f1/70/7703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7d/idna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "linkify-it-py" do
    url "https://files.pythonhosted.org/packages/2a/ae/bb56c6828e4797ba5a4821eec7c43b8bf40f69cda4d4f5f8c8a2810ec96a/linkify-it-py-2.0.3.tar.gz"
    sha256 "68cda27e162e9215c17d786649d1da0021a451bdc436ef9e0fa0ba5234b9b048"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/38/71/3b932df36c1a044d397a1f92d1cf91ee0a503d91e470cbd670aa66b07ed0/markdown-it-py-3.0.0.tar.gz"
    sha256 "e3f60a94fa066dc52ec76661e37c851cb232d92f9886b15cb560aaada2df8feb"
  end

  resource "mdit-py-plugins" do
    url "https://files.pythonhosted.org/packages/19/03/a2ecab526543b152300717cf232bb4bb8605b6edb946c845016fa9c9c9fd/mdit_py_plugins-0.4.2.tar.gz"
    sha256 "5f2cd1fdb606ddf152d37ec30e46101a60512bc0e5fa1a7002c36647b09e26b5"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "openapi-pydantic" do
    url "https://files.pythonhosted.org/packages/02/2e/58d83848dd1a79cb92ed8e63f6ba901ca282c5f09d04af9423ec26c56fd7/openapi_pydantic-0.5.1.tar.gz"
    sha256 "ff6835af6bde7a459fb93eb93bb92b8749b754fc6e51b2f1590a19dc3005ee0d"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/b6/2d/7d512a3913d60623e7eb945c6d1b4f0bddf1d0b7ada5225274c87e5b53d1/platformdirs-4.3.7.tar.gz"
    sha256 "eb437d586b6a0986388f0d6f74aa0cde27b48d0e3d66843640bfb6bdcdb6e351"
  end

  resource "pydantic" do
    url "https://files.pythonhosted.org/packages/b0/41/832125a41fe098b58d1fdd04ae819b4dc6b34d6b09ed78304fd93d4bc051/pydantic-2.11.2.tar.gz"
    sha256 "2138628e050bd7a1e70b91d4bf4a91167f4ad76fdb83209b107c8d84b854917e"
  end

  resource "pydantic-core" do
    url "https://files.pythonhosted.org/packages/17/19/ed6a078a5287aea7922de6841ef4c06157931622c89c2a47940837b5eecd/pydantic_core-2.33.1.tar.gz"
    sha256 "bcc9c6fdb0ced789245b02b7d6603e17d1563064ddcfc36f046b61c0c05dd9df"
  end

  resource "pydantic-settings" do
    url "https://files.pythonhosted.org/packages/88/82/c79424d7d8c29b994fb01d277da57b0a9b09cc03c3ff875f9bd8a86b2145/pydantic_settings-2.8.1.tar.gz"
    sha256 "d5c663dfbe9db9d5e1c646b2e161da12f0d734d422ee56f567d0ea2cee4e8585"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/7c/2d/c3338d48ea6cc0feb8446d8e6937e1408088a72a39937982cc6111d17f84/pygments-2.19.1.tar.gz"
    sha256 "61c16d2a8576dc0649d9f39e089b5f02bcd27fba10d8fb4dcc28173f7a45151f"
  end

  resource "pyperclip" do
    url "https://files.pythonhosted.org/packages/30/23/2f0a3efc4d6a32f3b63cdff36cd398d9701d26cda58e3ab97ac79fb5e60d/pyperclip-1.9.0.tar.gz"
    sha256 "b7de0142ddc81bfc5c7507eea19da920b92252b548b96186caf94a5e2527d310"
  end

  resource "python-dotenv" do
    url "https://files.pythonhosted.org/packages/88/2c/7bb1416c5620485aa793f2de31d3df393d3686aa8a8506d11e10e13c5baf/python_dotenv-1.1.0.tar.gz"
    sha256 "41f90bc6f5f177fb41f53e87666db362025010eb28f60a01c9143bfa33a2b2d5"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/54/ed/79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17/pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/a1/53/830aa4c3066a8ab0ae9a9955976fb770fe9c6102117c8ec4ab3ea62d89e8/rich-14.0.0.tar.gz"
    sha256 "82f1bc23a6a21ebca4ae0c45af9bdbc492ed20231dcb63f297d6d1021a9d5725"
  end

  resource "sniffio" do
    url "https://files.pythonhosted.org/packages/a2/87/a6771e1546d97e7e041b6ae58d80074f81b7d5121207425c964ddf5cfdbd/sniffio-1.3.1.tar.gz"
    sha256 "f4324edc670a0f49750a81b895f35c3adb843cca46f0530f79fc1babb23789dc"
  end

  resource "textual" do
    url "https://files.pythonhosted.org/packages/28/7f/9423d4d9e1aabaa6841a7f77e2bf8249a7cae4209c4d6b33d77f55ed24c3/textual-3.0.0.tar.gz"
    sha256 "0bf9f8523541340d5357724d60868db652fb287ac7b13e6cf4553d45a6d9a9d5"
  end

  resource "textual-autocomplete" do
    url "https://files.pythonhosted.org/packages/7a/cf/9cf23ac193c70e7b0a6999dc9409650e9ab9960b1be167e7dda54f1028a8/textual_autocomplete-4.0.4.tar.gz"
    sha256 "0969987b90a53c1f75753dfe3ad2c7ea0d974b5839dc2a00a2d332c000057871"
  end

  # Unmaintained package and so use a fork of original
  # Issue ref: https://github.com/Aider-AI/grep-ast/issues/7
  resource "tree-sitter-languages" do
    url "https://github.com/Textualize/py-tree-sitter-languages/archive/refs/tags/v1.11.0b0.tar.gz"
    sha256 "17b13f25f479e1ca39cddab1ec59541236ae25449ba136e70e842c3c8340c507"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/76/ad/cd3e3465232ec2416ae9b983f27b9e94dc8171d56ac99b345319a9475967/typing_extensions-4.13.1.tar.gz"
    sha256 "98795af00fb9640edec5b8e31fc647597b4691f099ad75f469a2616be1a76dff"
  end

  resource "typing-inspection" do
    url "https://files.pythonhosted.org/packages/82/5c/e6082df02e215b846b4b8c0b887a64d7d08ffaba30605502639d44c06b82/typing_inspection-0.4.0.tar.gz"
    sha256 "9765c87de36671694a67904bf2c96e395be9c6439bb6c87b5142569dcdd65122"
  end

  resource "uc-micro-py" do
    url "https://files.pythonhosted.org/packages/91/7a/146a99696aee0609e3712f2b44c6274566bc368dfe8375191278045186b8/uc-micro-py-1.0.3.tar.gz"
    sha256 "d321b92cff673ec58027c04015fcaa8bb1e005478643ff4a500882eaab88c48a"
  end

  resource "watchfiles" do
    url "https://files.pythonhosted.org/packages/f5/26/c705fc77d0a9ecdb9b66f1e2976d95b81df3cae518967431e7dbf9b5e219/watchfiles-1.0.4.tar.gz"
    sha256 "6ba473efd11062d73e4f00c2b730255f9c1bdd73cd5f9fe5b5da8dbd4a717205"
  end

  resource "xdg-base-dirs" do
    url "https://files.pythonhosted.org/packages/bf/d0/bbe05a15347538aaf9fa5b51ac3b97075dfb834931fcb77d81fbdb69e8f6/xdg_base_dirs-6.0.2.tar.gz"
    sha256 "950504e14d27cf3c9cb37744680a43bf0ac42efefc4ef4acf98dc736cab2bced"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(bin/"posting", shells: [:fish, :zsh], shell_parameter_format: :click)
  end

  test do
    # From the OpenAPI Spec website
    # https://web.archive.org/web/20230505222426/https://swagger.io/docs/specification/basic-structure/
    (testpath/"minimal.yaml").write <<~YAML
      ---
      openapi: 3.1.1
      info:
        version: "0.0.0"
        title: Sample API
      servers:
        - url: http://api.example.com/v1
          description: Optional server description, e.g. Main (production) server
        - url: http://staging-api.example.com
          description: Optional server description, e.g. Internal staging server for testing
      paths:
        /users:
          get:
            summary: Returns a list of users.
            responses:
              '200':
                description: A JSON array of user names
                content:
                  application/json:
                    schema:
                      type: array
                      items:
                        type: string
      components: {}
    YAML
    output = shell_output("#{bin}/posting import minimal.yaml")
    assert_match "Successfully imported OpenAPI spec", output
  end
end
