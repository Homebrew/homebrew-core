class PythonArgcomplete < Formula
  desc "Tab completion for Python argparse"
  homepage "https://kislyuk.github.io/argcomplete/"
  url "https://files.pythonhosted.org/packages/1b/c5/fb934dda06057e182f8247b2b13a281552cf55ba2b8b4450f6e003d0469f/argcomplete-3.1.2.tar.gz"
  sha256 "d5d1e5efd41435260b8f85673b74ea2e883affcbec9f4230c582689e8e78251b"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "be09a2338a78bf46bd53f6277be6ac094f9125ee7663a175d018830436c8efd4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f1286762e4558511f61691cdf5d1cb5863b9503ec0737d2c411a2fbfc648fec9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "25228e5004a6485eb8671fd21596c65a886377c5545b8f87740a06a0ad3b89f8"
    sha256 cellar: :any_skip_relocation, sonoma:         "89400bdabf4a2246723bf671f73618052ac25934c9a335a895f626ce1d28346c"
    sha256 cellar: :any_skip_relocation, ventura:        "ea522bbfb6f4b0cf57cf6b6c3a3aff6f6027e8dd4908a5ea70cb64496ab5c865"
    sha256 cellar: :any_skip_relocation, monterey:       "a192e02f6093118b4f5aa4c7627604139ee7e964b83b59c1da09afc870faf7b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d0270914f8473ce3756c7a7f3aa9a0187c9b5b1799c45eb4b5017d948370153e"
  end

  depends_on "python-setuptools" => :build
  depends_on "python@3.10" => [:build, :test]
  depends_on "python@3.11" => [:build, :test]
  depends_on "python@3.12" => [:build, :test]

  def pythons
    deps.map(&:to_formula).sort_by(&:version).filter { |f| f.name.start_with?("python@") }
  end

  def install
    pythons.each do |python|
      python_exe = python.opt_libexec/"bin/python"
      system python_exe, "-m", "pip", "install", *std_pip_args, "."
    end

    bash_completion.install "argcomplete/bash_completion.d/_python-argcomplete" => "python-argcomplete"
    zsh_completion.install_symlink bash_completion/"python-argcomplete" => "_python-argcomplete"
  end

  test do
    pythons.each do |python|
      python_exe = python.opt_libexec/"bin/python"
      system python_exe, "-c", "import argcomplete"
    end

    output = shell_output("#{bin}/register-python-argcomplete foo")
    assert_match "_python_argcomplete foo", output
  end
end
