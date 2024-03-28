class Djhtml < Formula
  include Language::Python::Virtualenv

  desc "Django/Jinja template indenter"
  homepage "https://github.com/rtts/djhtml"
  url "https://files.pythonhosted.org/packages/a0/03/aac9bfb7c9b03604a2c4b0d474af22731ef41cb662fad07f956ae7bf0f6b/djhtml-3.0.6.tar.gz"
  sha256 "abfc4d7b4730432ca6a98322fbdf8ae9d6ba254ea57ba3759a10ecb293bc57de"
  license "GPL-3.0-or-later"

  bottle do
    rebuild 3
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "eb0cd1d7c6d9df7ce258b8f13ba027bb47ee4b970f377e390a11b47ceb1106fc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5c67244a3b29b0770e28ce06e0863337ab966057d02da5b7c60b5595fd7a1994"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "52e1233ebc017d9a54bc1331ace6de8efbc00bed95b6ff0e0a0828fe164a6c9d"
    sha256 cellar: :any_skip_relocation, sonoma:         "d8dd4ee8bbd3b167bfaf7638e77c287a5ffcd2be8d3d32257e31a3a3f5aa0e07"
    sha256 cellar: :any_skip_relocation, ventura:        "db418a4bd9fa88d07e3f4ea993098cc2e5b4801fb685a8f658abe0eb5a8d9b8e"
    sha256 cellar: :any_skip_relocation, monterey:       "0f4ee105a833c36bee996677464474fd406fac5075c87b6cad30e6d902fba1da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3db67f111be77e432b82508d0479f8758be617ebd0d217b7512041dff1b16201"
  end

  depends_on "python@3.12"

  def install
    virtualenv_install_with_resources
  end

  test do
    test_file = testpath/"test.html"
    test_file.write <<~EOF
      <html>
      <p>Hello, World!</p>
      </html>
    EOF

    expected_output = <<~EOF
      <html>
        <p>Hello, World!</p>
      </html>
    EOF

    system bin/"djhtml", "--tabwidth", "2", test_file
    assert_equal expected_output, test_file.read
  end
end
