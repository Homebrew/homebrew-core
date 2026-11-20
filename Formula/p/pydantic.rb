class Pydantic < Formula
  include Language::Python::Virtualenv

  desc "Data validation using Python type hints"
  homepage "https://pydantic.dev/docs/validation"
  url "https://files.pythonhosted.org/packages/8e/25/3ec212432a6031b65f043eaca9c820ddf87c0d0aa330023e64f79fcb5db6/pydantic-2.14.4.tar.gz"
  sha256 "7c19f1d46f8accf55a4617a6116e1ade64840870f397b846a2c53fb9019414ba"
  license "MIT"
  version_scheme 1
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "5420ee9c73805b0d6c4b47deaf7940ee582fbb2ec21370b651793338bf78cb9e"
    sha256 cellar: :any, arm64_tahoe:       "084ef7731720ea993be2fc46bb8dbaa19c5ec55f46e8f33b1625cb281a6efaed"
    sha256 cellar: :any, arm64_sequoia:     "ea135ffa4ee2711d0a26421ff9db7efe2fc8e24004f2805cfa2276ad356a0070"
    sha256 cellar: :any, arm64_linux:       "aa0e8b9511ee64c1169c212ec171b471e2a70cb17c1e848f6a14b6524448e810"
    sha256 cellar: :any, x86_64_linux:      "2ca6c10354e98b24f1b096d45327bb9658898523af3436dc14697cdae7328b17"
  end

  depends_on "maturin" => :build
  depends_on "python@3.14" => [:build, :test]
  depends_on "python@3.15" => [:build, :test]
  depends_on "rust" => :build

  def pythons
    deps.map(&:to_formula)
        .select { |f| f.name.start_with?("python@") }
        .map { |f| f.opt_libexec/"bin/python" }
  end

  resource "annotated-types" do
    url "https://files.pythonhosted.org/packages/5f/56/a8120250d128bed162cd73c76d45f6ef9991f3e068f62a8ee060afa3104a/annotated_types-0.8.0.tar.gz"
    sha256 "13b2beaad985e05e2d6407ee4c4f35590b11f8d693a258a561055cac8f64cab7"
  end

  resource "pydantic-core" do
    url "https://files.pythonhosted.org/packages/fb/63/0ceb815a7762576027ce388544c573d440574f95afb1302a2496b96db548/pydantic_core-2.50.5.tar.gz"
    sha256 "1e740886083ff95530d694e6a3f09ed914bcf92a496d16acd307c6c3484fc36d"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/f6/cc/6253133b5bb138fc3306cebfbda2c520f545d36b5be2c7255cc528bb45d6/typing_extensions-4.16.0.tar.gz"
    sha256 "dc983d19a509c94dba722ee6abd33940f7c05a89e243c47e907eb4db6f1a43e5"
  end

  resource "typing-inspection" do
    url "https://files.pythonhosted.org/packages/ff/50/0195198eb1d75bab716bb0a813abea4cc394bfa17a92a189f021a34859af/typing_inspection-0.4.5.tar.gz"
    sha256 "7f16c411e7930dc79596d42ab44672a3fe5f60eb34b781a1647e7872363120c7"
  end

  allow_network_access! :build

  def install
    pythons.each do |python3|
      resources.each do |r|
        r.stage do
          build_isolation = r.name != "pydantic-core"
          system python3, "-m", "pip", "install", *std_pip_args(build_isolation:), "."
        end
      end

      system python3, "-m", "pip", "install", *std_pip_args(build_isolation: true), "."
    end
  end

  test do
    pythons.each do |python3|
      system python3, "-c", <<~PYTHON
        from pydantic import BaseModel, ValidationError

        class Model(BaseModel):
            value: int

        assert Model(value="42").model_dump() == {"value": 42}
        try:
            Model(value="invalid")
        except ValidationError as error:
            assert error.errors()[0]["type"] == "int_parsing"
        else:
            raise AssertionError("Invalid input was accepted")
      PYTHON
    end
  end
end
