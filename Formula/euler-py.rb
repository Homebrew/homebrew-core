class EulerPy < Formula
  desc "Project Euler command-line tool written in Python"
  homepage "https://github.com/iKevinY/EulerPy"
  url "https://github.com/iKevinY/EulerPy/archive/v1.3.0.tar.gz"
  sha256 "ffe2d74b5a0fbde84a96dfd39f1f899fc691e3585bf0d46ada976899038452e1"
  revision 1
  head "https://github.com/iKevinY/EulerPy.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "6bec5937c08632e5ea3073d9b948f89539939c19ba26844c739b18d3b8c79066" => :mojave
    sha256 "6f002b7c103b9cc799e559355d83228bf462079cff7f0cb6db9e041880e06c17" => :high_sierra
    sha256 "6f002b7c103b9cc799e559355d83228bf462079cff7f0cb6db9e041880e06c17" => :sierra
  end

  depends_on "python"

  resource "click" do
    url "https://files.pythonhosted.org/packages/source/c/click/click-4.0.tar.gz"
    sha256 "f49e03611f5f2557788ceeb80710b1c67110f97c5e6740b97edf70245eea2409"
  end

  def install
    xy = Language::Python.major_minor_version "python3"
    ENV.prepend_create_path "PYTHONPATH", "#{libexec}/lib/python#{xy}/site-packages"
    resource("click").stage do
      system "python3", "setup.py", "install", "--prefix=#{libexec}",
                        "--single-version-externally-managed",
                        "--record=installed.txt"
    end

    ENV.prepend_create_path "PYTHONPATH", "#{lib}/python#{xy}/site-packages"
    system "python", "setup.py", "install", "--prefix=#{prefix}",
                     "--single-version-externally-managed",
                     "--record=installed.txt"

    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    require "open3"
    Open3.popen3("#{bin}/euler") do |stdin, stdout, _|
      stdin.write("\n")
      stdin.close
      assert_match 'Successfully created "001.py".', stdout.read
    end
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
