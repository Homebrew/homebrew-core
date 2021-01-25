class EulerPy < Formula
  desc "Project Euler command-line tool written in Python"
  homepage "https://github.com/iKevinY/EulerPy"
  url "https://github.com/iKevinY/EulerPy/archive/v1.4.0.tar.gz"
  sha256 "0d2f633bc3985c8acfd62bc76ff3f19d0bfb2274f7873ec7e40c2caef315e46d"
  license "MIT"
  revision 1
  head "https://github.com/iKevinY/EulerPy.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "917e8e5cb6e2e0ddefb971d0e00e279eb6352155a149237470a0c9aabcb8ad73" => :big_sur
    sha256 "607e27b881164dc76352a8dcf7a09a5a38235ca1a2e9aa142b5170604f5371fb" => :arm64_big_sur
    sha256 "b5983d05f31d241d0fa6209c659076129f606aaaa8a6b34958822f80a194e56a" => :catalina
    sha256 "8aa6bb9a5d762c3b4836eb18b8a29428f451641af3ea21fe8bc5860b18fdbadb" => :mojave
    sha256 "ab94e651eff246074bb51d7984a5ba5e09f76ecbf2c8484e3f64409deb672de2" => :high_sierra
  end

  depends_on "python@3.9"

  resource "click" do
    url "https://files.pythonhosted.org/packages/7b/61/80731d6bbf0dd05fe2fe9bac02cd7c5e3306f5ee19a9e6b9102b5784cf8c/click-4.0.tar.gz"
    sha256 "f49e03611f5f2557788ceeb80710b1c67110f97c5e6740b97edf70245eea2409"
  end

  def install
    ENV["PYTHON"] = Formula["python@3.9"].opt_bin/"python3"

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
