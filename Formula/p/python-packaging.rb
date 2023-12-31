class PythonPackaging < Formula
  desc "Core utilities for Python packages"
  homepage "https://packaging.pypa.io/"
  url "https://files.pythonhosted.org/packages/fb/2b/9b9c33ffed44ee921d0967086d653047286054117d584f1b1a7c22ceaf7b/packaging-23.2.tar.gz"
  sha256 "048fb0e9405036518eaaf48a55953c750c11e1a1b68e0dd1a9d62ed0c092cfc5"
  license any_of: ["Apache-2.0", "BSD-2-Clause"]
  revision 1

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fc68dd6b701f0c370b1d538bfa3394d0d5dfffa5973880e834040c008b7fbe1e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fd248202a9d29dba96e3de77d14770fe1483fecec60ca12f7eac4ea18a0cf7a6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9ef8094a159ea9edbdbfb8f9399f76675a6a8df0ce04dc4eee6993d71032a679"
    sha256 cellar: :any_skip_relocation, sonoma:         "a090d7705a4cbdbfab9cd06d45628e14fcf6c5011f2a4497fa8940e59b0dbf92"
    sha256 cellar: :any_skip_relocation, ventura:        "a61d5e78c02f66997b4f39f0cca91a47227754654a53a01280b872fb074ae789"
    sha256 cellar: :any_skip_relocation, monterey:       "0fd9263a51f3b31ee2e60b3b03df1b7dec6f2b2cd55d3835f0600ca39d6c3a26"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0cf08b1acd67850b3f3ce886fe9194f9a2ebaf7eb9747012abd68eeb522067c9"
  end

  depends_on "python-flit-core" => :build
  depends_on "python@3.11" => [:build, :test]
  depends_on "python@3.12" => [:build, :test]

  def pythons
    deps.map(&:to_formula)
        .select { |f| f.name.start_with?("python@") }
        .map { |f| f.opt_libexec/"bin/python" }
  end

  def install
    pythons.each do |python|
      system python, "-m", "pip", "install", *std_pip_args, "."
    end
  end

  test do
    pythons.each do |python|
      system python, "-c", "import packaging"
    end
  end
end
