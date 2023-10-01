class PythonTypingExtensions < Formula
  desc "Backported and experimental type hints for Python"
  homepage "https://github.com/python/typing_extensions"
  url "https://files.pythonhosted.org/packages/1f/7a/8b94bb016069caa12fc9f587b28080ac33b4fbb8ca369b98bc0a4828543e/typing_extensions-4.8.0.tar.gz"
  sha256 "df8e4339e9cb77357558cbdbceca33c303714cf861d1eef15e1070055ae8b7ef"
  license "Python-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "929bc38a9d739276be2baa68ff25d7adcbd469ed6f4c35d0f3e596d91b5b686f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "156ebcbfa1417d709fbcb9652b7fe4d8b7c80851a130cd1487a41032b65e88bc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "df903f019ad19a03847d49e1c9c314b1487ebf3165237dc96affaff4732365bf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b31cd7c96ea59569d16a1d7a6fb2b54e94e9f39bb1ad9e763a40fa92a84aa260"
    sha256 cellar: :any_skip_relocation, sonoma:         "aea58a751d8b1b9fd8e15d9d139721433e6c3f4522e254c8e19fba0c03d3773a"
    sha256 cellar: :any_skip_relocation, ventura:        "51a7c46b5d2c640e8e417f85f71de2a93628635c5a47a718b072459e532c2920"
    sha256 cellar: :any_skip_relocation, monterey:       "5278ebee95997fc4b3a71a36f826a0fc5c7281c01fbf1f68b687e3d897dbb321"
    sha256 cellar: :any_skip_relocation, big_sur:        "c26c7e839a1d8552feb80b944dbcb780b8e7b0efbf37341f1d5b034e32efb852"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b5fee2c9238e8843366be019c746f480444d351f80e39c0454def672d3d4e79d"
  end

  depends_on "flit" => :build
  depends_on "python@3.10" => [:build, :test]
  depends_on "python@3.11" => [:build, :test]
  depends_on "mypy" => :test

  def pythons
    deps.select { |dep| dep.name.start_with?("python") }
        .map(&:to_formula)
        .sort_by(&:version)
  end

  def install
    system Formula["flit"].opt_bin/"flit", "build", "--format", "wheel"
    wheel = Pathname.glob("dist/typing_extensions-*.whl").first
    pythons.each do |python|
      system python.opt_libexec/"bin/pip", "install", *std_pip_args, wheel
    end
  end

  def caveats
    python_versions = pythons.map { |p| p.version.major_minor }
                             .map(&:to_s)
                             .join(", ")

    <<~EOS
      This formula provides the `typing_extensions` module for Python #{python_versions}.
      If you need `typing_extensions` for a different version of Python, use pip.
    EOS
  end

  test do
    pythons.each do |python|
      system python.opt_libexec/"bin/python", "-c", <<~EOS
        import typing_extensions
      EOS
    end

    (testpath/"test.py").write <<~EOS
      import typing_extensions

      class Movie(typing_extensions.TypedDict):
          title: str
          year: typing_extensions.NotRequired[int]

      m = Movie(title="Grease")
    EOS
    system "mypy", testpath/"test.py"
  end
end
