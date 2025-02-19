class CFormatter42 < Formula
  include Language::Python::Virtualenv

  desc "C language formatter for 42 norminette"
  homepage "https://github.com/dawnbeen/c_formatter_42"
  url "https://files.pythonhosted.org/packages/77/fa/edee608023d6adc567d1060b4b889b6279e0f99ff3b3cc58bfa4eda069dd/c_formatter_42-0.2.8.tar.gz"
  sha256 "da31b1ab4cdc92dd363ae791244cf063982e29c9fc54dbde0f22fce20a2b057b"
  license "GPL-3.0-only"
  head "https://github.com/dawnbeen/c_formatter_42.git", branch: "master"

  depends_on "python"

  def install
    python_version = Language::Python.major_minor_version "python3"
    odie "Python 3.8 or newer is required." if python_version < Version.new("3.8")
    virtualenv_install_with_resources
  end

  test do
    (testpath/"test.c").write <<~EOS
      int main()
      {
        return 0;
      }
    EOS
    output = shell_output("#{bin}/c_formatter_42 #{testpath}/test.c")
    assert_match "Writing to #{testpath}/test.c", output
    formatted_content = (testpath/"test.c").read
    expected_output = "int\tmain(void)\n{\n\treturn (0);\n}\n"
    assert_equal expected_output, formatted_content
  end
end
