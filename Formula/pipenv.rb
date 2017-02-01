class Pipenv < Formula
  include Language::Python::Virtualenv

  desc "Experimental virtualenv, and package manager for Python"
  homepage "https://github.com/kennethreitz/pipenv"
  url "https://github.com/kennethreitz/pipenv/archive/v3.2.11.tar.gz"
  sha256 "4dc7dcea983f0ecd8f3ca16e9249280271558bdffd0cc1bdca3bdf322f365d4e"

  option "without-completions", "Disable bash/fish/zsh completions"

  depends_on :python

  resource "backports.shutil_get_terminal_size" do
    url "https://files.pythonhosted.org/packages/ec/9c/368086faa9c016efce5da3e0e13ba392c9db79e3ab740b763fe28620b18b/backports.shutil_get_terminal_size-1.0.0.tar.gz"
    sha256 "713e7a8228ae80341c70586d1cc0a8caa5207346927e23d09dcbcaf18eadec80"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/95/d9/c3336b6b5711c3ab9d1d3a80f1a3e2afeb9d8c02a7166462f6cc96570897/click-6.7.tar.gz"
    sha256 "f15516df478d5a56180fbf80e68f206010e6d160fc39fa508b65e035fd75130b"
  end

  resource "click-completion" do
    url "https://files.pythonhosted.org/packages/d8/10/e2eead22c1893c2bd717b4dee55c72de5793fce38ee231211dd3858b012a/click-completion-0.2.1.tar.gz"
    sha256 "079fb138887d4de12a0b7fbebf8d92d396b7c1a9c49f63475d9f3909d2588976"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/f0/d0/21c6449df0ca9da74859edc40208b3a57df9aca7323118c913e58d442030/colorama-0.3.7.tar.gz"
    sha256 "e043c8d32527607223652021ff648fbb394d5e19cba9f1a698670b338c9d782b"
  end

  resource "crayons" do
    url "https://files.pythonhosted.org/packages/14/fa/635fdd47686a0f29692d927333fcf39e0279fc39c81704866c97adc34053/crayons-0.1.2.tar.gz"
    sha256 "5e17691605e564d63482067eb6327d01a584bbaf870beffd4456a3391bd8809d"
  end

  resource "delegator.py" do
    url "https://files.pythonhosted.org/packages/75/5d/eccdb1877da79cc4fad7222b382172707945c68cfa12056b57d422c88c80/delegator.py-0.0.8.tar.gz"
    sha256 "603c1c1c76b1340520d95a1e768cf2d3a8df7b3c15a1eb9df83aac29b8d025a4"
  end

  resource "Jinja2" do
    url "https://files.pythonhosted.org/packages/71/59/d7423bd5e7ddaf3a1ce299ab4490e9044e8dfd195420fc83a24de9e60726/Jinja2-2.9.5.tar.gz"
    sha256 "702a24d992f856fa8d5a7a36db6128198d0c21e1da34448ca236c42e92384825"
  end

  resource "MarkupSafe" do
    url "https://files.pythonhosted.org/packages/c0/41/bae1254e0396c0cc8cf1751cb7d9afc90a602353695af5952530482c963f/MarkupSafe-0.23.tar.gz"
    sha256 "a4ec1aff59b95a14b45eb2e23761a0179e98319da5a7eb76b56ea8cdc7b871c3"
  end

  resource "parse" do
    url "https://files.pythonhosted.org/packages/c3/e3/c2ca7f10c481b84ba7bf8c35c595ee4825d828fce7838fffc57f0ea0acc9/parse-1.6.6.tar.gz"
    sha256 "71435aaac494e08cec76de646de2aab8392c114e56fe3f81c565ecc7eb886178"
  end

  resource "pexpect" do
    url "https://files.pythonhosted.org/packages/e8/13/d0b0599099d6cd23663043a2a0bb7c61e58c6ba359b2656e6fb000ef5b98/pexpect-4.2.1.tar.gz"
    sha256 "3d132465a75b57aa818341c6521392a06cc660feb3988d7f1074f39bd23c9a92"
  end

  resource "pipfile" do
    url "https://files.pythonhosted.org/packages/08/3d/6a46d06d3b68ef766121c55391ba0bec123de76ca10d7323329e14777cda/pipfile-0.0.1.tar.gz"
    sha256 "1047107f2cc8c2a3c7c46b934485c44f0808f4c72cdbca930385021b93315458"
  end

  resource "ptyprocess" do
    url "https://files.pythonhosted.org/packages/db/d7/b465161910f3d1cef593c5e002bff67e0384898f597f1a7fdc8db4c02bf6/ptyprocess-0.5.1.tar.gz"
    sha256 "0530ce63a9295bfae7bd06edc02b6aa935619f486f0f1dc0972f516265ee81a6"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/16/09/37b69de7c924d318e51ece1c4ceb679bf93be9d05973bb30c35babd596e2/requests-2.13.0.tar.gz"
    sha256 "5722cd09762faa01276230270ff16af7acf7c5c45d623868d9ba116f15791ce8"
  end

  resource "requirements-parser" do
    url "https://files.pythonhosted.org/packages/2d/45/ed1be0fa777cbddd352e94f942e9acc26bba403091d98c86f5ce3780b344/requirements-parser-0.1.0.tar.gz"
    sha256 "fee2380a469ffe4067bc7f0096a6fcfb27539da7496fae12b74b8d5d0f33a4ee"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/b3/b2/238e2590826bfdd113244a40d9d3eb26918bd798fc187e2360a8367068db/six-1.10.0.tar.gz"
    sha256 "105f8d68616f8248e24bf0e9372ef04d3cc10104f1980f54d57b2ce73a5ad56a"
  end

  resource "toml" do
    url "https://files.pythonhosted.org/packages/5c/b2/8a18ced00a43f2cc5261f9ac9f1c94621251400a80db1567177719355177/toml-0.9.2.tar.gz"
    sha256 "b3953bffe848ad9a6d554114d82f2dcb3e23945e90b4d9addc9956f37f336594"
  end

  resource "virtualenv" do
    url "https://files.pythonhosted.org/packages/d4/0c/9840c08189e030873387a73b90ada981885010dd9aea134d6de30cd24cb8/virtualenv-15.1.0.tar.gz"
    sha256 "02f8102c2436bb03b3ee6dede1919d1dac8a427541652e5ec95171ec8adbc93a"
  end

  def install
    virtualenv_install_with_resources
    if build.with? "completions"
      Dir.mkdir("completions")
      system "_PIPENV_COMPLETE=source-bash #{bin}/pipenv > completions/pipenv"
      system "_PIPENV_COMPLETE=source-fish #{bin}/pipenv > completions/pipenv.fish"
      system "_PIPENV_COMPLETE=source-zsh #{bin}/pipenv > completions/_pipenv"
      bash_completion.install "completions/pipenv"
      fish_completion.install "completions/pipenv.fish"
      zsh_completion.install "completions/_pipenv"
    end
  end

  def caveats; <<-EOS.undent
    To use Python 3 virtualenvs, `brew install python3`.
    EOS
  end

  test do
    assert_match "Commands",
      shell_output("#{bin}/pipenv")
    assert_equal false, File.exist?("Pipfile")
    system "#{bin}/pipenv", "install", "requests"
    assert_equal true, File.exist?("Pipfile")
    assert_equal true, Dir.exist?(".venv")
    assert_match "requests", shell_output("cat Pipfile")
    system "#{bin}/pipenv", "lock"
    assert_equal true, File.exist?("Pipfile.lock")
    if build.with? "completions"
      assert_match "-F _pipenv",
        shell_output("bash -c 'source #{bash_completion}/pipenv && complete -p pipenv'")
    end
  end
end
