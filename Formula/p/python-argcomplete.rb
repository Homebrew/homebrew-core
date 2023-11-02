class PythonArgcomplete < Formula
  desc "Tab completion for Python argparse"
  homepage "https://kislyuk.github.io/argcomplete/"
  url "https://files.pythonhosted.org/packages/ef/c8/e95f413b7af4fc489bff7cd14f2b061b237966cf46733eb67893a04c8a22/argcomplete-3.1.3.tar.gz"
  sha256 "0ded993e146148e0fe4ebafd3563d56fbcd0adbe39bc3001b351739e599e9223"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0f478f7a5c92ec90898fd0662e02a464e036bef64d902cfc8f21280bfdc2c52c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "516e02689901777f76a15e39ef4f1e8c8305a89ec7f5c61ec4dc41cbb24f0b59"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2f43a674e720d8cdc611208f3a449276eccad296392061267557dd63b69ba336"
    sha256 cellar: :any_skip_relocation, sonoma:         "2a2baec5cd2d316da3c39eb70c87c151f05f25dac59b11f04026e2f8da828581"
    sha256 cellar: :any_skip_relocation, ventura:        "059475f93317c004e19fd9c9116eac2151d80855d8920fe813e5810a50e90fbd"
    sha256 cellar: :any_skip_relocation, monterey:       "5fc0d472a836f8d896bac270f2c2d836de11c57129cae476c6708d19e8efa501"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7312a27bb7bb774a6419d32bcc098046d2fca8466bc80cb58e5c38e2ffa4abc5"
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
