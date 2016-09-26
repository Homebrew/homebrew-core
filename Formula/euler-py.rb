class EulerPy < Formula
  desc "Project Euler command-line tool written in Python"
  homepage "https://github.com/iKevinY/EulerPy"
  url "https://github.com/iKevinY/EulerPy/archive/v1.3.0.tar.gz"
  sha256 "ffe2d74b5a0fbde84a96dfd39f1f899fc691e3585bf0d46ada976899038452e1"

  head "https://github.com/iKevinY/EulerPy.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "c5ee4cdc8330f84084b0b145b9183b6c21683de758a3f052158f3dc6d0d6adb8" => :sierra
    sha256 "4c887a4af203e4991ff844f4836663cbaf1afc835ae8c628d769e32ff0f1e4e1" => :el_capitan
    sha256 "69ffb29dd9b1f1fdf6fa7ecf31871c5010a06a94eda99e916681aac73d9bca15" => :yosemite
    sha256 "6006f400f9f2e010c104325f4e1903c8fe825884b54ef88bea47918b58876576" => :mavericks
  end

  depends_on :python if MacOS.version <= :snow_leopard

  resource "click" do
    url "https://pypi.python.org/packages/source/c/click/click-4.0.tar.gz"
    sha256 "f49e03611f5f2557788ceeb80710b1c67110f97c5e6740b97edf70245eea2409"
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", "#{libexec}/lib/python2.7/site-packages"
    resource("click").stage do
      system "python", "setup.py", "install", "--prefix=#{libexec}",
             "--single-version-externally-managed", "--record=installed.txt"
    end

    ENV.prepend_create_path "PYTHONPATH", "#{lib}/python2.7/site-packages"
    system "python", "setup.py", "install", "--prefix=#{prefix}",
           "--single-version-externally-managed", "--record=installed.txt"

    bin.env_script_all_files(libexec+"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    require "open3"
    Open3.popen3("#{bin}/euler") do |stdin, stdout, _|
      stdin.write("\n")
      stdin.close
      assert_match 'Successfully created "001.py".', stdout.read
    end
    assert_equal 0, $?.exitstatus
  end
end
