class AwsSsoUtil < Formula
  include Language::Python::Virtualenv

  desc "Smooth out the rough edges of AWS SSO (temporarily, until AWS makes it better)"
  homepage "https://github.com/benkehoe/aws-sso-util"
  url "https://files.pythonhosted.org/packages/4f/64/f00272ecbc60703d0f1a3b17ab75d893c05ec5d60b0e6e9d59ef9b8b9c61/aws_sso_util-4.33.0.tar.gz"
  sha256 "e48d7f5911443450d28e1ac1613f81b9aa15babb1b2055b4531df87db43a09df"
  license "Apache-2.0"
  revision 3
  head "https://github.com/benkehoe/aws-sso-util.git", branch: "master"

  bottle do
    rebuild 3
    sha256 cellar: :any,                 arm64_tahoe:   "613eafb6c9aca830f9a0598d24ccfe7c659fb31902226bc2a31df17ea0fd5e42"
    sha256 cellar: :any,                 arm64_sequoia: "9643a028947f8ebf5075e1a697b340a165f4a164269c3f5acc5d97ed754156ac"
    sha256 cellar: :any,                 arm64_sonoma:  "3cc77192eefb4938c7f348c00601a3d7efd75ded9cc812c3e9b46bb76d3d284e"
    sha256 cellar: :any,                 sonoma:        "9e2eba970867b8683286d1e42af6faa8b2cf7368b184ec013ff596627a289b41"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d60c98c57bf091e24313d9fed321c759c76b4d8d6b3ce58c659c0713697ec1b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "84c48a6849418f6bc1404fc14dd0352d9735d5eb81262c32a820f5c0486e8d92"
  end

  depends_on "certifi" => :no_linkage
  depends_on "libyaml"
  depends_on "python@3.14"
  depends_on "rpds-py" => :no_linkage

  pypi_packages exclude_packages: ["certifi", "rpds-py"]

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/6b/5c/685e6633917e101e5dcb62b9dd76946cbb57c26e133bae9e0cd36033c0a9/attrs-25.4.0.tar.gz"
    sha256 "16d5969b87f0859ef33a48b35d55ac1be6e42ae49d5e853b597db70c35c57e11"
  end

  resource "aws-error-utils" do
    url "https://files.pythonhosted.org/packages/2a/fc/2541892cafad6658e9ce5226e54088eff9692cbe4a32cd5a7dfec5846cbf/aws_error_utils-2.7.0.tar.gz"
    sha256 "07107af2a2c26706cd9525b7ffbed43f2d07b50d27e39f9e9156c11b2e993c97"
  end

  resource "aws-sso-lib" do
    url "https://files.pythonhosted.org/packages/3d/df/302bafc5e7182212eec091269c4731bb4469041a1db5e6c3643d089d135d/aws_sso_lib-1.14.0.tar.gz"
    sha256 "b0203a64ccb66ba78f99ef3d0eb669affe7bc323f6ab9caac97f35c21a03cea5"
  end

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/50/d8/a279c054e0c9731172f05b3d118f3ffc9d74806657f84fc0c93c42d1bb5d/boto3-1.40.55.tar.gz"
    sha256 "27e35b4fa9edd414ce06c1a748bf57cacd8203271847d93fc1053e4a4ec6e1a9"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/a4/92/dce4842b2e215d213d34b064fcdd13c6a782c43344e77336bcde586e9229/botocore-1.40.55.tar.gz"
    sha256 "79b6472e2de92b3519d44fc1eec8c5feced7f99a0d10fdea6dc93133426057c1"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/13/69/33ddede1939fdd074bce5434295f38fae7136463422fe4fd3e0e89b98062/charset_normalizer-3.4.4.tar.gz"
    sha256 "94537985111c35f28720e43603b8e7b43a6ecfb2ce1d3058bbe955b73404e21a"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/46/61/de6cd827efad202d7057d93e0fed9294b96952e188f7384832791c7b2254/click-8.3.0.tar.gz"
    sha256 "e7b8232224eba16f4ebe410c25ced9f7875cb5f3263ffc93cc3e8da705e229c4"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/6f/6d/0703ccc57f3a7233505399edb88de3cbd678da106337b9fcde432b65ed60/idna-3.11.tar.gz"
    sha256 "795dafcc9c04ed0c1fb032c2aa73654d8e8c5023a7df64a53f39190ada629902"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/00/2a/e867e8531cf3e36b41201936b7fa7ba7b5702dbef42922193f05c8976cd6/jmespath-1.0.1.tar.gz"
    sha256 "90261b206d6defd58fdd5e85f478bf633a2901798906be2ad389150c5c60edbe"
  end

  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/74/69/f7185de793a29082a9f3c7728268ffb31cb5095131a9c139a74078e27336/jsonschema-4.25.1.tar.gz"
    sha256 "e4a9655ce0da0c0b67a085847e00a3a51449e1157f4f75e9fb5aa545e122eb85"
  end

  resource "jsonschema-specifications" do
    url "https://files.pythonhosted.org/packages/19/74/a633ee74eb36c44aa6d1095e7cc5569bebf04342ee146178e2d36600708b/jsonschema_specifications-2025.9.1.tar.gz"
    sha256 "b540987f239e745613c7a9176f3edb72b832a4ac465cf02712288397832b5e8d"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "referencing" do
    url "https://files.pythonhosted.org/packages/22/f5/df4e9027acead3ecc63e50fe1e36aca1523e1719559c499951bb4b53188f/referencing-0.37.0.tar.gz"
    sha256 "44aefc3142c5b842538163acb373e24cce6632bd54bdb01b21ad5863489f50d8"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/c9/74/b3ff8e6c8446842c3f5c837e9c3dfcfe2018ea6ecef224c710c85ef728f4/requests-2.32.5.tar.gz"
    sha256 "dbba0bac56e100853db0ea71b82b4dfd5fe2bf6d3754a8893c3af500cec7d7cf"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/62/74/8d69dcb7a9efe8baa2046891735e5dfe433ad558ae23d9e3c14c633d1d58/s3transfer-0.14.0.tar.gz"
    sha256 "eff12264e7c8b4985074ccce27a3b38a485bb7f7422cc8046fee9be4983e4125"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/15/22/9ee70a2574a4f4599c47dd506532914ce044817c7752a79b6a51286319bc/urllib3-2.5.0.tar.gz"
    sha256 "3fc47733c7e419d4bc3f6b3dc2b4f890bb743906a30d56ba4a5bfa4bbff92760"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(bin/"aws-sso-util", shell_parameter_format: :click)
  end

  test do
    cmd = "#{bin}/aws-sso-util configure profile invalid " \
          "--sso-start-url https://example.com/start --sso-region eu-west-1 " \
          "--account-id 000000000000 --role-name InvalidRole " \
          "--region eu-west-1 --non-interactive"

    assert_empty shell_output "AWS_CONFIG_FILE=#{testpath}/config #{cmd}"

    assert_path_exists testpath/"config"

    expected = <<~EOS

      [profile invalid]
      sso_start_url = https://example.com/start
      sso_region = eu-west-1
      sso_account_id = 000000000000
      sso_role_name = InvalidRole
      region = eu-west-1
      credential_process = aws-sso-util credential-process --profile invalid
    EOS

    assert_equal expected, (testpath/"config").read
  end
end
