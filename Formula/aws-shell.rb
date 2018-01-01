class AwsShell < Formula
  desc "Integrated shell for working with the AWS CLI"
  homepage "https://github.com/awslabs/aws-shell"
  url "https://files.pythonhosted.org/packages/ea/a0/0fba732444bdc23580f5e0290b8a6732b47a934c1978d108407704b01eec/aws-shell-0.2.0.tar.gz"
  sha256 "b46a673b81254e5e014297e08c9ecab535773aa651ca33dc3786a1fd612f9810"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "bcf11cf566551b154bdae41b623a47edf70e6434e24e34997dabfa817aaf3ce2" => :high_sierra
    sha256 "07acd0d0820ac23928cc09294965ba0d940fc87ccbe70ca96f8a59f5b23a6dd5" => :sierra
    sha256 "adfcbbdfe945223c373cd4c9eb8f2ef45d35cbcd9c860ce81d49647f8311a65d" => :el_capitan
  end

  # Use :python on Lion to avoid urllib3 warning
  # https://github.com/Homebrew/homebrew/pull/37240
  depends_on "python" if MacOS.version <= :lion

  resource "awscli" do
    url "https://files.pythonhosted.org/packages/34/c6/02f25ab114e5812146e9ef4ed21c2cf5aaea05c55237d4ab255b91de5a39/awscli-1.11.144.tar.gz"
    sha256 "3109ecb35e92d1191917419dbd6060808e0971fdda1fd943cf74556bf88d7017"
  end

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/b6/7c/b9caa157b514e0a456286172862428a83814e4eda114ea1e80267de85378/boto3-1.4.7.tar.gz"
    sha256 "f79f77dca2280f7780f39d72a5088f4cf2b626c0921e7185ed6ac17abfdd7e6c"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/f5/3d/5bd79b78c74e45859d89066e0c5efa777eddc78f939b99759336de17ff9f/botocore-1.7.2.tar.gz"
    sha256 "375cb4a995828851452d5a0266cd121b3bf6bd0181df47c2a5b66c39f91cade7"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/f0/d0/21c6449df0ca9da74859edc40208b3a57df9aca7323118c913e58d442030/colorama-0.3.7.tar.gz"
    sha256 "e043c8d32527607223652021ff648fbb394d5e19cba9f1a698670b338c9d782b"
  end

  resource "configobj" do
    url "https://files.pythonhosted.org/packages/64/61/079eb60459c44929e684fa7d9e2fdca403f67d64dd9dbac27296be2e0fab/configobj-5.0.6.tar.gz"
    sha256 "a2f5650770e1c87fb335af19a9b7eb73fc05ccf22144eb68db7d00cd2bcb0902"
  end

  resource "docutils" do
    url "https://files.pythonhosted.org/packages/84/f4/5771e41fdf52aabebbadecc9381d11dea0fa34e4759b4071244fa094804c/docutils-0.14.tar.gz"
    sha256 "51e64ef2ebfb29cae1faa133b3710143496eca21c530f3f71424d77687764274"
  end

  resource "futures" do
    url "https://files.pythonhosted.org/packages/cc/26/b61e3a4eb50653e8a7339d84eeaa46d1e93b92951978873c220ae64d0733/futures-3.1.1.tar.gz"
    sha256 "51ecb45f0add83c806c68e4b06106f90db260585b25ef2abfcda0bd95c0132fd"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/e5/21/795b7549397735e911b032f255cff5fb0de58f96da794274660bca4f58ef/jmespath-0.9.3.tar.gz"
    sha256 "6a81d4c9aa62caf061cb517b4d9ad1dd300374cd4706997aff9cd6aedd61fc64"
  end

  resource "prompt_toolkit" do
    url "https://files.pythonhosted.org/packages/8a/ad/cf6b128866e78ad6d7f1dc5b7f99885fb813393d9860778b2984582e81b5/prompt_toolkit-1.0.15.tar.gz"
    sha256 "858588f1983ca497f1cf4ffde01d978a3ea02b01c8a26a8bbc5cd2e66d816917"
  end

  resource "pyasn1" do
    url "https://files.pythonhosted.org/packages/33/4b/b3838af9a0bd1d17463031cf28cb1c196618900ccf80b62979f48c42768b/pyasn1-0.3.3.tar.gz"
    sha256 "01c20ade412088b42dcd5f0fef6149f6b7377297c5c5f222bb5ef0331ee3517c"
  end

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/71/2a/2e4e77803a8bd6408a2903340ac498cb0a2181811af7c9ec92cb70b0308a/Pygments-2.2.0.tar.gz"
    sha256 "dbae1046def0efb574852fab9e90209b23f556367b5a320c0bcb871c77c3e8cc"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/54/bb/f1db86504f7a49e1d9b9301531181b00a1c7325dc85a29160ee3eaa73a54/python-dateutil-2.6.1.tar.gz"
    sha256 "891c38b2a02f5bb1be3e4793866c8df49c7d19baabf9c1bad62547e0b4866aca"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/4a/85/db5a2df477072b2902b0eb892feb37d88ac635d36245a72a6a69b23b383a/PyYAML-3.12.tar.gz"
    sha256 "592766c6303207a20efc445587778322d7f73b161bd994f227adaa341ba212ab"
  end

  resource "rsa" do
    url "https://files.pythonhosted.org/packages/14/89/adf8b72371e37f3ca69c6cb8ab6319d009c4a24b04a31399e5bd77d9bb57/rsa-3.4.2.tar.gz"
    sha256 "25df4e10c263fb88b5ace923dd84bf9aa7f5019687b5e55382ffcdb8bede9db5"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/a8/58/d264e95e1b19a811fc52ff41c95dafd9c70cc7457b658bc04d87dfad31de/s3transfer-0.1.11.tar.gz"
    sha256 "76f1f58f4a47e2c8afa135e2c76958806a3abbc42b721d87fd9d11409c75d979"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/b3/b2/238e2590826bfdd113244a40d9d3eb26918bd798fc187e2360a8367068db/six-1.10.0.tar.gz"
    sha256 "105f8d68616f8248e24bf0e9372ef04d3cc10104f1980f54d57b2ce73a5ad56a"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/55/11/e4a2bb08bb450fdbd42cc709dd40de4ed2c472cf0ccb9e64af22279c5495/wcwidth-0.1.7.tar.gz"
    sha256 "3df37372226d6e63e1b1e1eda15c594bca98a22d33a23832a90998faa96bc65e"
  end

  def install
    ENV["PYTHONPATH"] = libexec/"lib/python2.7/site-packages"
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"

    resources.each do |r|
      r.stage do
        system "python", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    system "python", *Language::Python.setup_install_args(libexec)
    bin.install Dir[libexec/"bin/*"]
    env = {
      :PATH => "#{libexec}/vendor/bin:$PATH",
      :PYTHONPATH => ENV["PYTHONPATH"],
    }
    bin.env_script_all_files(libexec/"bin", env)
  end

  test do
    system "#{bin}/aws-shell", "--help"
  end
end
