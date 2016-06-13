class Awscli < Formula
  desc "Official Amazon AWS command-line interface"
  homepage "https://aws.amazon.com/cli/"
  url "https://pypi.python.org/packages/0e/27/1189968c900f9ad8f62c1483479bde13088d15172f68a81bfd5cfc3014dd/awscli-1.10.37.tar.gz"
  sha256 "bf2b926a73e2eaed7ec1084a93408116da8d4884babf79bfa524cf4b1e57c40d"

  bottle do
    cellar :any_skip_relocation
    sha256 "3ba24fe0107b430287046f5a6d60f890d97e64a3fcf7d25c45dd304e9dfa438d" => :el_capitan
    sha256 "b8ea22cd3a063fd5cf2f0bb73a7f76bb1342a32def51da40445e0a31d2727cc3" => :yosemite
    sha256 "8491cc37f056d6cffeebc2976f2b328bce010500daf02479b3d0bd097f05f279" => :mavericks
  end

  head do
    url "https://github.com/aws/aws-cli.git", :branch => "develop"

    resource "botocore" do
      url "https://github.com/boto/botocore.git", :branch => "develop"
    end

    resource "jmespath" do
      url "https://github.com/boto/jmespath.git", :branch => "develop"
    end

    resource "s3transfer" do
      url "https://github.com/boto/s3transfer.git", :branch => "develop"
    end
  end

  # Use :python on Lion to avoid urllib3 warning
  # https://github.com/Homebrew/homebrew/pull/37240
  depends_on :python if MacOS.version <= :lion

  resource "six" do
    url "https://pypi.python.org/packages/b3/b2/238e2590826bfdd113244a40d9d3eb26918bd798fc187e2360a8367068db/six-1.10.0.tar.gz"
    sha256 "105f8d68616f8248e24bf0e9372ef04d3cc10104f1980f54d57b2ce73a5ad56a"
  end

  resource "python-dateutil" do
    url "https://pypi.python.org/packages/3e/f5/aad82824b369332a676a90a8c0d1e608b17e740bbb6aeeebca726f17b902/python-dateutil-2.5.3.tar.gz"
    sha256 "1408fdb07c6a1fa9997567ce3fcee6a337b39a503d80699e0f213de4aa4b32ed"
  end

  resource "colorama" do
    url "https://pypi.python.org/packages/24/84/29ce4167d1f5c4a320aaad91e1178e5a1baf9cfe1c63f9077c5dade0e3cc/colorama-0.3.3.tar.gz"
    sha256 "eb21f2ba718fbf357afdfdf6f641ab393901c7ca8d9f37edd0bee4806ffa269c"
  end

  resource "botocore" do
    url "https://pypi.python.org/packages/3c/7e/59920da3ec8ea9f841bb56a4f9ee8f595b8005f743bfec3c63c9e411afd1/botocore-1.4.27.tar.gz"
    sha256 "1d18565c45ab1eeb7e5e237c7aa1ce81b6376fa63e5a9d948c5bcdfb5fe27d75"
  end

  resource "jmespath" do
    url "https://pypi.python.org/packages/8f/d8/6e3e602a3e90c5e3961d3d159540df6b2ff32f5ab2ee8ee1d28235a425c1/jmespath-0.9.0.tar.gz"
    sha256 "08dfaa06d4397f283a01e57089f3360e3b52b5b9da91a70e1fd91e9f0cdd3d3d"
  end

  resource "s3transfer" do
    url "https://pypi.python.org/packages/6e/12/5d0ea478e6d261857a461af921b78f3bc6f92c479ffe57076f4fc9a362ab/s3transfer-0.0.1.tar.gz"
    sha256 "2bb9ed8db58af94dfa78f75f554d646dfe4b4741fc87f63a20c2bfb3f70f4355"
  end

  resource "futures" do
    url "https://pypi.python.org/packages/55/db/97c1ca37edab586a1ae03d6892b6633d8eaa23b23ac40c7e5bbc55423c78/futures-3.0.5.tar.gz"
    sha256 "0542525145d5afc984c88f914a0c85c77527f65946617edb5274f72406f981df"
  end

  resource "docutils" do
    url "https://pypi.python.org/packages/37/38/ceda70135b9144d84884ae2fc5886c6baac4edea39550f28bcd144c1234d/docutils-0.12.tar.gz"
    sha256 "c7db717810ab6965f66c8cf0398a98c9d8df982da39b4cd7f162911eb89596fa"
  end

  resource "pyasn1" do
    url "https://pypi.python.org/packages/f7/83/377e3dd2e95f9020dbd0dfd3c47aaa7deebe3c68d3857a4e51917146ae8b/pyasn1-0.1.9.tar.gz"
    sha256 "853cacd96d1f701ddd67aa03ecc05f51890135b7262e922710112f12a2ed2a7f"
  end

  resource "rsa" do
    url "https://pypi.python.org/packages/14/89/adf8b72371e37f3ca69c6cb8ab6319d009c4a24b04a31399e5bd77d9bb57/rsa-3.4.2.tar.gz"
    sha256 "25df4e10c263fb88b5ace923dd84bf9aa7f5019687b5e55382ffcdb8bede9db5"
  end

  resource "tox" do
    url "https://pypi.python.org/packages/46/39/e15a857fda1852da1485bc88ac4268dbcef037ab526e1ac21accf2a5c24c/tox-2.3.1.tar.gz"
    sha256 "bf7fcc140863820700d3ccd65b33820ba747b61c5fe4e2b91bb8c64cb21a47ee"
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

    # Install zsh completion
    zsh_completion.install "bin/aws_zsh_completer.sh" => "_aws"

    # Install the examples
    pkgshare.install "awscli/examples"

    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec+"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  def caveats; <<-EOS.undent
    The "examples" directory has been installed to:
      #{HOMEBREW_PREFIX}/share/awscli/examples

    Add the following to ~/.bashrc to enable bash completion:
      complete -C aws_completer aws

    Add the following to ~/.zshrc to enable zsh completion:
      source #{HOMEBREW_PREFIX}/share/zsh/site-functions/_aws

    Before using awscli, you need to tell it about your AWS credentials.
    The easiest way to do this is to run:
      aws configure

    More information:
      https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-getting-started.html
    EOS
  end

  test do
    system "#{bin}/aws", "--version"
  end
end
