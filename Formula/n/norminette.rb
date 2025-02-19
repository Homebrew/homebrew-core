class Norminette < Formula
  include Language::Python::Virtualenv

  desc "Official 42 norminette"
  homepage "https://github.com/42School/norminette"
  url "https://files.pythonhosted.org/packages/32/7d/a7bd0a9eab47b0e23874996d62bc9af39328b7e9e939f29340330d56f4c5/norminette-3.3.55.tar.gz"
  sha256 "66356de519fdd361043ea1473ea5317b6087ce60c9f1f2fb172aaf3f7fcfe98c"
  license "MIT"
  head "https://github.com/42School/norminette.git", branch: "master"

  depends_on "python"

  def install
    python_version = Language::Python.major_minor_version "python3"
    odie "Python 3.8 or newer is required." if python_version < Version.new("3.8")
    virtualenv_install_with_resources
  end

  test do
    assert_match "norminette", shell_output("#{bin}/norminette --version")
    (testpath/"blank.c").write ""
    output = shell_output("#{bin}/norminette blank.c")
    assert_equal "blank.c: OK!", output.chomp
    (testpath/"test.c").write <<~EOF
      #include <stdio.h>
    EOF
    output = shell_output("#{bin}/norminette test.c", 1)
    expect = <<~EOF
      test.c: Error!
      Error: INVALID_HEADER       (line:   1, col:   1):	Missing or invalid 42 header
    EOF
    assert_equal expect, output
  end
end
