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

    (bash_completion/"pdm").write Utils.safe_popen_read(libexec/"bin/pdm", "completion", "bash")
    (zsh_completion/"_pdm").write Utils.safe_popen_read(libexec/"bin/pdm", "completion", "zsh")
    (fish_completion/"pdm.fish").write Utils.safe_popen_read(libexec/"bin/pdm", "completion", "fish")

    bin.install_symlink(libexec/"bin/pdm")
  end

  test do
    (testpath/"pyproject.toml").write <<~EOS
      [tool.pdm]
      python_requires = ">=3.8"

      [tool.pdm.dependencies]

      [tool.pdm.dev-dependencies]
    EOS
    system bin/"pdm", "add", "requests==2.24.0"
    assert_match "[tool.pdm.dependencies]\nrequests = \"==2.24.0\"", (testpath/"pyproject.toml").read
    assert_predicate testpath/"pdm.lock", :exist?
    assert_match "name = \"urllib3\"", (testpath/"pdm.lock").read
    output = shell_output("#{bin}/pdm run python -c 'import requests;print(requests.__version__)'")
    assert_equal "2.24.0", output.strip
  end
end
