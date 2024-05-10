class Pawk < Formula
  include Language::Python::Shebang

  desc "Python line processor (like AWK)"
  homepage "https://github.com/alecthomas/pawk"
  url "https://files.pythonhosted.org/packages/6c/90/2165e9fedd33ac172899aa3df6754971d720bf07eef2a0b049db15a7ad69/pawk-0.8.1.tar.gz"
  sha256 "59ec1a4046cf545e1376c8c0a28f5f178a3b88dbc85fb3772aa3ce8c2e088349"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ac3b1c476a0e40e5eed34672c9d426989456b17907cfeee03c6e6ed88d0d01b9"
  end

  uses_from_macos "python"

  def install
    rewrite_shebang detected_python_shebang(use_python_from_path: true), "pawk.py"
    bin.install "pawk.py" => "pawk"
  end

  test do
    (testpath/"elements.txt").write <<~EOS
      # Name Symbol
      Hydrogen  H
      Helium    He
      Lithium   Li
    EOS
    output = shell_output("#{bin}/pawk -B 'd={}' -E 'json.dumps(d)' '!/^#/ d[f[1]] = f[0]' < elements.txt")
    assert_equal '{"H": "Hydrogen", "He": "Helium", "Li": "Lithium"}', output.strip
  end
end
