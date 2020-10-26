class Pdm < Formula
  desc "Modern Python package manager with PEP 582 support"
  homepage "https://pdm.fming.dev"
  url "https://files.pythonhosted.org/packages/74/4f/dcbbd585bb43a7210e97ee83b514c25060b4537022b082a3ce661def8bad/pdm-0.10.0.tar.gz"
  sha256 "34300685359501666eb28862e6cee4197d1ccff909edd34b6670136dbb4609da"
  license "MIT"
  head "https://github.com/frostming/pdm.git"

  depends_on "python@3.9"

  def install
    # Generate requirements from locked file
    system Formula["python@3.9"].opt_bin/"python3", "-m", "venv", libexec
    system libexec/"bin/pip", "install", "."

    Dir.mkdir "./completions"
    system "#{libexec}/bin/pdm completion bash > ./completions/pdm"
    system "#{libexec}/bin/pdm completion zsh > ./completions/_pdm"
    system "#{libexec}/bin/pdm completion fish > ./completions/pdm.fish"
    bash_completion.install "./completions/pdm"
    zsh_completion.install "./completions/_pdm"
    fish_completion.install "./completions/pdm.fish"

    bin.install_symlink(libexec/"bin/pdm")
  end

  test do
    _, status = Open3.capture2(bin/"pdm", "--help")
    assert_equal status, 0
    (testpath/"pyproject.toml").write <<~EOS
      [tool.pdm]
      name = "test-pdm"
      version = "0.0.0"
      python_requires = ">=3.8"

      [tool.pdm.dependencies]

      [tool.pdm.dev-dependencies]
    EOS
    system bin/"pdm", "add", "requests"
    assert_match "[tool.pdm.dependencies]\nrequests", (testpath/"pyproject.toml").read
    assert_predicate testpath/"pdm.lock", :exist?
    assert_predicate testpath/"__pypackages__/3.9/lib/requests", :exist?
    assert_match "name = \"urllib3\"", (testpath/"pdm.lock").read
    _, status = Open3.capture2(bin/"pdm", "run", "python", "-c", "import requests")
    assert_equal status, 0
  end
end
