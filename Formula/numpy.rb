class Numpy < Formula
  desc "Package for scientific computing with Python"
  homepage "https://www.numpy.org/"
  url "https://files.pythonhosted.org/packages/64/4a/b008d1f8a7b9f5206ecf70a53f84e654707e7616a771d84c05151a4713e9/numpy-1.22.3.zip"
  sha256 "dbc7601a3b7472d559dc7b933b18b4b66f9aa7452c120e87dfb33d02008c8a18"
  license "BSD-3-Clause"
  head "https://github.com/numpy/numpy.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_monterey: "0a82053a086d3fdabb49ba60be5088ddfd192a59e5301c47b964a15e04b47c9b"
    sha256 cellar: :any, arm64_big_sur:  "1e57920ffffc06e4f2cf676aded79b3a0bd1b1a8f264c6f57df731c55076e10f"
    sha256 cellar: :any, monterey:       "cf646852b393e1907969538fa3ce3cb6788427cc5d0ec2a333e9c78c212073e7"
    sha256 cellar: :any, big_sur:        "87184fc6f1976c958f4b192f741914634664f400c82be9d21dd9591e04b464b8"
    sha256 cellar: :any, catalina:       "63889b2b8c2d804c5561cb28ee18ed3b4aea0b516698973235a57c6d77027e8e"
    sha256               x86_64_linux:   "4a5591fa46462c0f7b4d589c3854c8a3bc3e21f0f04065c2c4596840f6df3ef0"
  end

  depends_on "cython" => :build
  depends_on "gcc" => :build # for gfortran
  depends_on "openblas"
  depends_on "python@3.9"

  fails_with gcc: "5"

  def install
    openblas = Formula["openblas"].opt_prefix
    ENV["ATLAS"] = "None" # avoid linking against Accelerate.framework
    ENV["BLAS"] = ENV["LAPACK"] = "#{openblas}/lib/#{shared_library("libopenblas")}"

    config = <<~EOS
      [openblas]
      libraries = openblas
      library_dirs = #{openblas}/lib
      include_dirs = #{openblas}/include
    EOS

    Pathname("site.cfg").write config

    xy = Language::Python.major_minor_version Formula["python@3.9"].opt_bin/"python3"
    ENV.prepend_create_path "PYTHONPATH", Formula["cython"].opt_libexec/"lib/python#{xy}/site-packages"

    system Formula["python@3.9"].opt_bin/"python3", "setup.py", "build",
        "--fcompiler=#{Formula["gcc"].opt_bin}/gfortran", "--parallel=#{ENV.make_jobs}"
    system Formula["python@3.9"].opt_bin/"python3", *Language::Python.setup_install_args(prefix)
  end

  test do
    system Formula["python@3.9"].opt_bin/"python3", "-c", <<~EOS
      import numpy as np
      t = np.ones((3,3), int)
      assert t.sum() == 9
      assert np.dot(t, t).sum() == 27
    EOS
  end
end
