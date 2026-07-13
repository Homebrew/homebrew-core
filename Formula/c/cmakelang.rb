class Cmakelang < Formula
  include Language::Python::Virtualenv

  desc "CMake language tools: formatter, linter, parser, semantic markup generator, etc."
  homepage "https://github.com/cheshirekow/cmake_format"
  url "https://github.com/cheshirekow/cmake_format/archive/refs/tags/v0.6.13.tar.gz"
  sha256 "b67dd150380d9223036a12f82126a7a9b18e77db4a8d7240f993ee090884e4bf"
  license "GPL-3.0-only"
  head "https://github.com/cheshirekow/cmake_format.git", branch: "master"

  depends_on "python-setuptools" => :build
  depends_on "python@3.14"

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  def install
    venv = virtualenv_create(libexec, "python3.14")
    venv.pip_install resources, build_isolation: false

    # Upstream's setup.py builds five distributions, which is incompatible with PEP 517.
    system "python3.14", "setup.py", "bdist_wheel", "--dist-dir=dist"
    wheel = buildpath.glob("dist/cmakelang-*.whl").fetch(0)
    venv.pip_install_and_link wheel
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cmake-format --version") unless build.head?

    (testpath/"CMakeLists.txt").write <<~CMAKE
      project( Test )
      function (greet person)
        message(
          STATUS
          "Hello ${person}"
        )
        endfunction()
    CMAKE

    assert_equal <<~CMAKE, shell_output("#{bin}/cmake-format CMakeLists.txt")
      project(Test)
      function(greet person)
        message(STATUS "Hello ${person}")
      endfunction()
    CMAKE

    assert_match "Bad indentation", shell_output("#{bin}/cmake-lint CMakeLists.txt", 1)

    assert_match '<span class="cmf-FUNNAME">', shell_output("#{bin}/cmake-annotate CMakeLists.txt")

    system bin/"cmake-genparsers", "--output-format=json", "--outfile-path=parsers.json", "CMakeLists.txt"
    JSON.parse (testpath/"parsers.json").read

    assert_match "CTestTestfile.cmake does not exist", shell_output("#{bin}/ctest-to 2>&1")
  end
end
