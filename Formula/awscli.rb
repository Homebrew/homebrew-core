class Awscli < Formula
  desc "Official Amazon AWS command-line interface"
  homepage "https://aws.amazon.com/cli/"
  url "https://pypi.python.org/packages/cf/07/fdff021a20c557b466c64cd545b838b05741922d3563dafdd07fbf041f07/awscli-1.10.32.tar.gz"
  sha256 "70942f5b7b52f1802de29552127f9552d2cabcf03b34438bf985d73a4a9540dc"

  bottle do
    cellar :any_skip_relocation
    sha256 "721bf98906bb59772fbd76f7624737962f2a990b71022fc9542399d4e1b18190" => :el_capitan
    sha256 "a7e54c97bcc7a0b7bc255163e2033095ee465166efb4a182c785027c329cf49f" => :yosemite
    sha256 "bb464a969a21cad85b606a995da69775d8bdad571b87d28c8d7972a5aea659eb" => :mavericks
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
    url "https://pypi.python.org/packages/source/s/six/six-1.10.0.tar.gz"
    sha256 "105f8d68616f8248e24bf0e9372ef04d3cc10104f1980f54d57b2ce73a5ad56a"
  end

  resource "python-dateutil" do
    url "https://pypi.python.org/packages/source/p/python-dateutil/python-dateutil-2.4.2.tar.gz"
    sha256 "3e95445c1db500a344079a47b171c45ef18f57d188dffdb0e4165c71bea8eb3d"
  end

  resource "colorama" do
    url "https://pypi.python.org/packages/source/c/colorama/colorama-0.3.3.tar.gz"
    sha256 "eb21f2ba718fbf357afdfdf6f641ab393901c7ca8d9f37edd0bee4806ffa269c"
  end

  resource "botocore" do
    url "https://pypi.python.org/packages/14/ed/aa8f059990fcf8489e95d1e612c2c0b061ec96460f4912a00085abd9d62d/botocore-1.4.22.tar.gz"
    sha256 "9807c405e85ed5af817529b04194150cfe37277bbf6879cff1a9c9b5d75311ef"
  end

  resource "jmespath" do
    url "https://pypi.python.org/packages/source/j/jmespath/jmespath-0.9.0.tar.gz"
    sha256 "08dfaa06d4397f283a01e57089f3360e3b52b5b9da91a70e1fd91e9f0cdd3d3d"
  end

  resource "s3transfer" do
    url "https://pypi.python.org/packages/source/s/s3transfer/s3transfer-0.0.1.tar.gz"
    sha256 "2bb9ed8db58af94dfa78f75f554d646dfe4b4741fc87f63a20c2bfb3f70f4355"
  end

  resource "futures" do
    url "https://pypi.python.org/packages/source/f/futures/futures-3.0.5.tar.gz"
    sha256 "0542525145d5afc984c88f914a0c85c77527f65946617edb5274f72406f981df"
  end

  resource "docutils" do
    url "https://pypi.python.org/packages/source/d/docutils/docutils-0.12.tar.gz"
    sha256 "c7db717810ab6965f66c8cf0398a98c9d8df982da39b4cd7f162911eb89596fa"
  end

  resource "pyasn1" do
    url "https://pypi.python.org/packages/source/p/pyasn1/pyasn1-0.1.9.tar.gz"
    sha256 "853cacd96d1f701ddd67aa03ecc05f51890135b7262e922710112f12a2ed2a7f"
  end

  resource "rsa" do
    url "https://pypi.python.org/packages/source/r/rsa/rsa-3.3.tar.gz"
    sha256 "03f3d9bebad06681771016b8752a40b12f615ff32363c7aa19b3798e73ccd615"
  end

  resource "tox" do
    url "https://pypi.python.org/packages/source/t/tox/tox-2.3.1.tar.gz"
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
