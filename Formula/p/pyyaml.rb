class Pyyaml < Formula
  desc "YAML parser for Python"
  homepage "https://pyyaml.org/"
  url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
  sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  license "MIT"
  head "https://github.com/yaml/pyyaml.git", branch: "main"

  depends_on "cython" => :build
  depends_on "python-setuptools" => :build
  depends_on "python@3.14" => [:build, :test]
  depends_on "python@3.15" => [:build, :test]
  depends_on "libyaml"

  def pythons
    deps.map(&:to_formula)
        .select { |f| f.name.start_with?("python@") }
        .map { |f| f.opt_libexec/"bin/python" }
  end

  def install
    pythons.each do |python3|
      system python3, "-m", "pip", "install", *std_pip_args, "."
    end
  end

  test do
    (testpath/"test.py").write <<~PYTHON
      import yaml
      from io import StringIO
      document = """
        a: 1
        hello: hi
      """
      print(yaml.safe_load(StringIO(document)))
    PYTHON

    pythons.each do |python3|
      assert_match "{'a': 1, 'hello': 'hi'}", shell_output("#{python3} test.py")
    end
  end
end
