class EulerPy < Formula
  desc "Project Euler command-line tool written in Python"
  homepage "https://github.com/iKevinY/EulerPy"
  url "https://github.com/iKevinY/EulerPy/archive/v1.3.0.tar.gz"
  sha256 "ffe2d74b5a0fbde84a96dfd39f1f899fc691e3585bf0d46ada976899038452e1"
  revision 1
  head "https://github.com/iKevinY/EulerPy.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "c057672da8bc304a9483e353103cab54c50ec149269d0f597b28c0ded5121362" => :mojave
    sha256 "474ce35d2bd7beca1a7d63c0bec4cb162f9f2144d20695a6a58436433955492f" => :high_sierra
    sha256 "474ce35d2bd7beca1a7d63c0bec4cb162f9f2144d20695a6a58436433955492f" => :sierra
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
    system "python3", "setup.py", "install", "--prefix=#{prefix}",
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
