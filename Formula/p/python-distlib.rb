class PythonDistlib < Formula
  desc "Library which implements some Python packaging standards (PEPs)"
  homepage "https://distlib.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/c4/91/e2df406fb4efacdf46871c25cde65d3c6ee5e173b7e5a4547a47bae91920/distlib-0.3.8.tar.gz"
  sha256 "1530ea13e350031b6312d8580ddb6b27a104275a31106523b8f123787f494f64"
  license "PSF-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1c186d522fb510338fdd5aa7f1cb4a26f4cc7c8a4c60b22fdd5f77725af46327"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2608f66b742f612de2d3dd489cd660f181e9c13ff2bd5499c5b39011ea19c505"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "22272b08c51730f363c7990bc7a295e12e989e31bcd9bdacb31e5c108ab5c21a"
    sha256 cellar: :any_skip_relocation, sonoma:         "1e0a98f105cc1729b35a932fff1925e28465c39be321dbd806469451d68c6999"
    sha256 cellar: :any_skip_relocation, ventura:        "1291a6db0cd5e8cda26ec5cd452a116f2852ca00aee5b032adac24f0c8ec4c44"
    sha256 cellar: :any_skip_relocation, monterey:       "6cd0029d1664b8eca18224de5262c326eb19010bee60e7db2c8867a1bd034c38"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "acc9a5c1b72ade6a4778117afc05e4c728255eb48a81c8e9591c2c033e5192ff"
  end

  depends_on "python-setuptools" => :build
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
  end

  test do
    pythons.each do |python|
      python_exe = python.opt_libexec/"bin/python"
      system python_exe, "-c", "from distlib.database import DistributionPath"
    end
  end
end
