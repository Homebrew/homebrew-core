class Opendoor < Formula
  include Language::Python::Virtualenv

  desc "CLI for web reconnaissance, directory discovery, and exposure assessment"
  homepage "https://github.com/stanislav-web/OpenDoor"
  url "https://files.pythonhosted.org/packages/b8/3f/898d4bed6e592eac7f4ee222720b06b59e7ec6b109e876bebfa2b029ae34/opendoor-5.15.2.tar.gz"
  sha256 "3b6b57d3f528111433e1921a1157de3143e7b7bebc9145ff5a9bedbfb6b316ef"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "0eecb0fad237e0b14195d3c0afed6b468e7ed4e1eb6330cdd0eb9ba7120964f2"
  end

  depends_on "python@3.14"

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/df/de/0d2b39fb4af88a0258f3bac87dfcbb48e73fbdea4a2ed0e2213f9a4c2f9a/packaging-26.1.tar.gz"
    sha256 "f042152b681c4bfac5cae2742a55e103d27ab2ec0f3d88037136b6bfe7c9c5de"
  end

  resource "pysocks" do
    url "https://files.pythonhosted.org/packages/bd/11/293dd436aea955d45fc4e8a35b6ae7270f5b8e00b53cf6c024c83b657a11/PySocks-1.7.1.tar.gz"
    sha256 "3f8804571ebe159c380ac6de37643bb4685970655d3bba243530d6558b799aa0"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "tabulate" do
    url "https://files.pythonhosted.org/packages/46/58/8c37dea7bbf769b20d58e7ace7e5edfe65b849442b00ffcdd56be88697c6/tabulate-0.10.0.tar.gz"
    sha256 "e2cfde8f79420f6deeffdeda9aaec3b6bc5abce947655d17ac662b126e48a60d"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/c7/24/5f1b3bdffd70275f6661c76461e25f024d5a38a46f04aaca912426a2b1d3/urllib3-2.6.3.tar.gz"
    sha256 "1b62b6884944a57dbe321509ab94fd4d3b307075e0c2eae991ac71ee15ad38ed"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    port = free_port
    wordlist = testpath/"wordlist.txt"

    wordlist.write ["opendoor-health.txt", "missing-opendoor.txt", ""].join(10.chr)
    (testpath/"opendoor-health.txt").write "ok"

    server_pid = spawn Formula["python@3.14"].opt_bin/"python3.14",
                       "-m", "http.server", port.to_s,
                       "--bind", "127.0.0.1",
                       "--directory", testpath.to_s

    sleep 2

    output = shell_output(
      "#{bin}/opendoor --host 127.0.0.1 --port #{port} --scheme http:// " \
      "--scan directories --method GET --wordlist #{wordlist} " \
      "--threads 1 --include-status 200 --debug -1 2>&1",
    )

    assert_match "opendoor-health.txt", output
    refute_match "missing-opendoor.txt", output
  ensure
    Process.kill("TERM", server_pid)
    Process.wait(server_pid)
  end
end
