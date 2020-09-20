class PassImport < Formula
  include Language::Python::Virtualenv

  desc "Extension for pass to import data from other password managers"
  homepage "https://www.passwordstore.org/"
  url "https://github.com/roddhjav/pass-import/releases/download/v3.0/pass-import-3.0.tar.gz"
  sha256 "14f6708df990b88c54b07e722686ed9e1a639300b33d2ff83dd87845e44779fc"
  license "GPL-3.0-only"

  depends_on "gnupg"
  depends_on "pass"
  depends_on "python@3.8"

  resource "pyaml" do
    url "https://files.pythonhosted.org/packages/f1/cc/01712c4fa0e5b6f9f90d01d5adc46c9ad14bb6284406d13cde3ed7392082/pyaml-20.4.0.tar.gz"
    sha256 "29a5c2a68660a799103d6949167bd6c7953d031449d08802386372de1db6ad71"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/64/c2/b80047c7ac2478f9501676c988a5411ed5572f35d1beff9cae07d321512c/PyYAML-5.3.1.tar.gz"
    sha256 "b8eac752c5e14d3eca0e6dd9199cd627518cb5ec06add0de9d32baeee6fe645d"
  end

  def install
    system Formula["python@3.8"].opt_bin/"python3", *Language::Python.setup_install_args(prefix)
    virtualenv_install_with_resources
    bin.install "scripts/pimport"
    (lib/"password-store/extensions").install "scripts/import.bash"
    bash_completion.install "completion/pimport.bash" => "pimport"
    bash_completion.install "completion/pass-import.bash" => "pass-import"
    zsh_completion.install "completion/pimport.zsh" => "_pimport"
    zsh_completion.install "completion/pass-import.zsh" => "_pass-import"
    man1.install "docs/pass-import.1"
    man1.install "docs/pimport.1"
  end

  test do
    (testpath/"batch.gpg").write <<~EOS
      Key-Type: RSA
      Key-Length: 2048
      Subkey-Type: RSA
      Subkey-Length: 2048
      Name-Real: Testing
      Name-Email: testing@foo.bar
      Expire-Date: 1d
      %no-protection
      %commit
    EOS

    (testpath/"chrome.csv").write <<~EOS
      name,url,username,password
      "twitter.com","https://twitter.com/","ostqxi","SoNEwvU,kJ%-cIKJ9[c#S;]jB"
    EOS
    begin
      system Formula["gnupg"].opt_bin/"gpg", "--batch", "--gen-key", "batch.gpg"
      system Formula["pass"].bin/"pass", "init", "Testing"
      system bin/"pimport", "-o", testpath/".password-store", "pass", testpath/"chrome.csv"

      assert_predicate testpath/".password-store/twitter.com.gpg", :exist?
    ensure
      system Formula["gnupg"].opt_bin/"gpgconf", "--kill", "gpg-agent"
    end
  end
end
