class Djhtml < Formula
  include Language::Python::Virtualenv

  desc "Django/Jinja template indenter"
  homepage "https://github.com/rtts/djhtml"
  url "https://files.pythonhosted.org/packages/b6/30/17f6a99d40dfe37196be0872313fac8baa00815d0a8d1e2a2aabe25110ef/djhtml-1.4.10.tar.gz"
  sha256 "8575a10d17774eb261a5e756aeb847f6a592001aa3e4dcd3c23d88e6874407c7"
  license "GPL-3.0-or-later"

  depends_on "python@3.10"

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"test.html").write <<~EOF
      <html>
      <p>Hello, World!</p>
      </html>
    EOF

    expected_output = <<~EOF
      <html>
        <p>Hello, World!</p>
      </html>
    EOF
    assert_equal expected_output, shell_output("#{bin}/djhtml --tabwidth 2 test.html")
  end
end
