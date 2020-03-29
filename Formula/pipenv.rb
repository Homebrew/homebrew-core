class Pipenv < Formula
  include Language::Python::Virtualenv

  desc "Python dependency management tool"
  homepage "https://pipenv.kennethreitz.org/"
  url "https://files.pythonhosted.org/packages/fd/e9/01822318551caa0d62a181ba3b10f0f3757bb1e270da97165bd52db92776/pipenv-2018.11.26.tar.gz"
  sha256 "a673e606e8452185e9817a987572b55360f4d28b50831ef3b42ac3cab3fee846"
  revision 4

  bottle do
    cellar :any_skip_relocation
    sha256 "d8835620147f13436c15400db7d12d1d5b72769c7b67c5fe7f7a1d0e1dcbd88f" => :catalina
    sha256 "ccac725119c70e8f857e23d9448a61079697711aa5ad4a6a9b3b95ab5f747e5f" => :mojave
    sha256 "e58ee2436caed1a20c18b45067f1c28b987e542e7ebac17fe4d20f4e556f2b47" => :high_sierra
  end

  depends_on "python@3.8"

  resource "appdirs" do
    url "https://files.pythonhosted.org/packages/48/69/d87c60746b393309ca30761f8e2b49473d43450b150cb08f3c6df5c11be5/appdirs-1.4.3.tar.gz"
    sha256 "9e5896d1372858f8dd3344faf4e5014d21849c756c8d5701f78f8a103b372d92"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/41/bf/9d214a5af07debc6acf7f3f257265618f1db242a3f8e49a9b516f24523a6/certifi-2019.11.28.tar.gz"
    sha256 "25b64c7da4cd7479594d035c08c2d809eb4aab3a26e5a990ea98cc450c320f1f"
  end

  resource "distlib" do
    url "https://files.pythonhosted.org/packages/7d/29/694a3a4d7c0e1aef76092e9167fbe372e0f7da055f5dcf4e1313ec21d96a/distlib-0.3.0.zip"
    sha256 "2e166e231a26b36d6dfe35a48c4464346620f8645ed0ace01ee31822b288de21"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/14/ec/6ee2168387ce0154632f856d5cc5592328e9cf93127c5c9aeca92c8c16cb/filelock-3.0.12.tar.gz"
    sha256 "18d82244ee114f543149c66a6e0c14e9c4f8a1044b5cdaadd0f82159d6a6ff59"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/21/9f/b251f7f8a76dec1d6651be194dfba8fb8d7781d10ab3987190de8391d08e/six-1.14.0.tar.gz"
    sha256 "236bdbdce46e6e6a3d61a337c0f8b763ca1e8717c03b369e87a7ec7ce1319c0a"
  end

  resource "virtualenv" do
    url "https://files.pythonhosted.org/packages/d0/b6/2c6da6a79279023c305c4b1d974daec075d5e59cddd88d820d136976ad8a/virtualenv-20.0.10.tar.gz"
    sha256 "8512e83f1d90f8e481024d58512ac9c053bf16f54d9138520a0929396820dd78"
  end

  resource "virtualenv-clone" do
    url "https://files.pythonhosted.org/packages/d7/a7/08b88808c409722361459f1ae24474530d83593d6ded346f1d3649326838/virtualenv-clone-0.5.3.tar.gz"
    sha256 "c88ae171a11b087ea2513f260cdac9232461d8e9369bcd1dc143fc399d220557"
  end

  def install
    # Using the virtualenv DSL here because the alternative of using
    # write_env_script to set a PYTHONPATH breaks things.
    # https://github.com/Homebrew/homebrew-core/pull/19060#issuecomment-338397417
    venv = virtualenv_create(libexec, "python3")
    venv.pip_install resources
    venv.pip_install buildpath

    # `pipenv` needs to be able to find `virtualenv` on PATH. So we
    # install symlinks for those scripts in `#{libexec}/tools` and create a
    # wrapper script for `pipenv` which adds `#{libexec}/tools` to PATH.
    (libexec/"tools").install_symlink libexec/"bin/pip", libexec/"bin/virtualenv"
    env = {
      :PATH => "#{libexec}/tools:$PATH",
    }
    (bin/"pipenv").write_env_script(libexec/"bin/pipenv", env)

    output = Utils.popen_read("SHELL=bash #{libexec}/bin/pipenv --completion")
    (bash_completion/"pipenv").write output

    output = Utils.popen_read("SHELL=zsh #{libexec}/bin/pipenv --completion")
    (zsh_completion/"_pipenv").write output
  end

  # Avoid relative paths
  def post_install
    lib_python_path = Pathname.glob(libexec/"lib/python*").first
    lib_python_path.each_child do |f|
      next unless f.symlink?

      realpath = f.realpath
      rm f
      ln_s realpath, f
    end
  end

  test do
    ENV["LC_ALL"] = "en_US.UTF-8"
    assert_match "Commands", shell_output("#{bin}/pipenv")
    system "#{bin}/pipenv", "install", "requests"
    system "#{bin}/pipenv", "install", "boto3"
    assert_predicate testpath/"Pipfile", :exist?
    assert_predicate testpath/"Pipfile.lock", :exist?
    assert_match "requests", (testpath/"Pipfile").read
    assert_match "boto3", (testpath/"Pipfile").read
  end
end
