class EulerPy < Formula
  desc "Project Euler command-line tool written in Python"
  homepage "https://github.com/iKevinY/EulerPy"
  url "https://github.com/iKevinY/EulerPy/archive/v1.4.0.tar.gz"
  sha256 "0d2f633bc3985c8acfd62bc76ff3f19d0bfb2274f7873ec7e40c2caef315e46d"
  license "MIT"
  revision 2
  head "https://github.com/iKevinY/EulerPy.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "1913cf5a79895977ea9c9bf1e6c3d2e76fb965ebb062c86087859fbd80ecc227"
  end

  depends_on "python@3.11"

  resource "click" do
    url "https://files.pythonhosted.org/packages/7b/61/80731d6bbf0dd05fe2fe9bac02cd7c5e3306f5ee19a9e6b9102b5784cf8c/click-4.0.tar.gz"
    sha256 "f49e03611f5f2557788ceeb80710b1c67110f97c5e6740b97edf70245eea2409"
  end

  def install
    ENV["PYTHON"] = python3 = which("python3.11")
    site_packages = Language::Python.site_packages(python3)

    ENV.prepend_create_path "PYTHONPATH", libexec/site_packages
    resource("click").stage do
      system python3, *Language::Python.setup_install_args(libexec, python3)
    end

    ENV.prepend_create_path "PYTHONPATH", prefix/site_packages
    system python3, *Language::Python.setup_install_args(prefix, python3)

    bin.env_script_all_files(libexec/"bin", PYTHONPATH: ENV["PYTHONPATH"])
  end

  test do
    require "open3"
    output = Open3.capture2("#{bin}/euler", stdin_data: "\n")
    # output[0] is the stdout text, output[1] is the exit code
    assert_match 'Successfully created "001.py".', output[0]
    assert_equal 0, output[1]
    assert_predicate testpath/"001.py", :exist?
  end
end
