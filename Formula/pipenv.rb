class Pipenv < Formula
  include Language::Python::Virtualenv

  desc "Python dependency management tool"
  homepage "https://pipenv.kennethreitz.org/"
  url "https://files.pythonhosted.org/packages/fd/e9/01822318551caa0d62a181ba3b10f0f3757bb1e270da97165bd52db92776/pipenv-2018.11.26.tar.gz"
  sha256 "a673e606e8452185e9817a987572b55360f4d28b50831ef3b42ac3cab3fee846"
  revision 3

  bottle do
    cellar :any_skip_relocation
    sha256 "db8a0ff25976267cfe7abc95a5a4660dc2e30ee7b96c447019c7ac53e4303300" => :catalina
    sha256 "b9cb743f74deb9a403e0c1a4cc9131658874035ae79c4a7462ad08a8f96bdad5" => :mojave
    sha256 "0c078b19e35de1e9834049a8c1836285a5a85b483ce8ffa90263c138e71f6161" => :high_sierra
  end

  depends_on "python@3.8"

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/41/bf/9d214a5af07debc6acf7f3f257265618f1db242a3f8e49a9b516f24523a6/certifi-2019.11.28.tar.gz"
    sha256 "25b64c7da4cd7479594d035c08c2d809eb4aab3a26e5a990ea98cc450c320f1f"
  end

  resource "virtualenv" do
    url "https://files.pythonhosted.org/packages/aa/3b/213c384c65e17995cccd0f2bb993b7b82c41f62e74c2f8f39c8e60549d86/virtualenv-16.7.9.tar.gz"
    sha256 "0d62c70883c0342d59c11d0ddac0d954d0431321a41ab20851facf2b222598f3"
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
