class Dnspython < Formula
  include Language::Python::Virtualenv

  desc "Powerful DNS toolkit for python"
  homepage "https://www.dnspython.org"
  url "https://github.com/rthalley/dnspython/releases/download/v2.6.1/dnspython-2.6.1.tar.gz"
  sha256 "e8f0f9c23a7b7cb99ded64e6c3a6f3e701d78f50c55e002b839dea7225cff7cc"
  license "ISC"

  depends_on "python-setuptools" => :build
  depends_on "python@3.12" => [:build, :test]

  def install
    virtualenv_install_with_resources
  end


  def pythons
    deps.map(&:to_formula)
        .select { |f| f.name.start_with?("python@") }
        .map { |f| f.opt_libexec/"bin/python" }
  end


  test do


   runfile = testpath/"test.py"
    #
    (runfile).write << ˜EOS

    import dns.resolver 

    answers = dns.resolver.resolve('www.dnspython.org', 'A')


    print(answers[1].address)

EOS

expected_output = '52.85.92.33'


  pythons.each do |python|
      python_exe = python.opt_libexec/"bin/python"
      system python_exe, "-c", "import dns.resolver;"


    assert_equal expected_output, shell_output( python_exe runfile)


  end
end
