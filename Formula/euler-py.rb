class EulerPy < Formula
  desc "Project Euler command-line tool written in Python"
  homepage "https://github.com/iKevinY/EulerPy"
  url "https://github.com/iKevinY/EulerPy/archive/v1.4.0.tar.gz"
  sha256 "0d2f633bc3985c8acfd62bc76ff3f19d0bfb2274f7873ec7e40c2caef315e46d"
  license "MIT"
  revision 2
  head "https://github.com/iKevinY/EulerPy.git"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "5fc159b1ad9e6d6cd8fd7f7ab14186f6e894e0be2f46d6966f13f72723effec2"
  end

  depends_on "python@3.10"

  resource "click" do
    url "https://files.pythonhosted.org/packages/7b/61/80731d6bbf0dd05fe2fe9bac02cd7c5e3306f5ee19a9e6b9102b5784cf8c/click-4.0.tar.gz"
    sha256 "f49e03611f5f2557788ceeb80710b1c67110f97c5e6740b97edf70245eea2409"
  end

  def install
    ENV["PYTHON"] = Formula["python@3.10"].opt_bin/"python3"

    xy = Language::Python.major_minor_version "python3"
    ENV.prepend_create_path "PYTHONPATH", "#{libexec}/lib/python#{xy}/site-packages"
    resource("click").stage do
      system "python3", "setup.py", "install", "--prefix=#{libexec}",
                        "--single-version-externally-managed",
                        "--record=installed.txt"
    end

    ENV.prepend_create_path "PYTHONPATH", "#{lib}/python#{xy}/site-packages"
    system "python3", "setup.py", "install", "--prefix=#{prefix}",
                      "--single-version-externally-managed",
                      "--record=installed.txt"

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
