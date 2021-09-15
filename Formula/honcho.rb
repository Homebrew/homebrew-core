class Honcho < Formula
  desc "Python clone of Foreman, for managing Procfile-based applications"
  homepage "https://github.com/nickstenning/honcho"
  url "https://files.pythonhosted.org/packages/a2/8b/c404bce050eba79a996f6901f35445a53c1133b0424b33e58a4ad225bc37/honcho-1.0.1.tar.gz"
  sha256 "c189402ad2e337777283c6a12d0f4f61dc6dd20c254c9a3a4af5087fc66cea6e"
  license "MIT"
  revision 3
  head "https://github.com/nickstenning/honcho.git"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "45d84a15c2312ed91f5abe9ac993184bea7deb4a08ef3e51ba6271b268eee1f0"
    sha256 cellar: :any_skip_relocation, big_sur:       "7cfd5e890b357ad7bb3a96687d1ec9bc97aff24d7aadf2b6df21e34e3901c78d"
    sha256 cellar: :any_skip_relocation, catalina:      "3f509a6f7aced41359a42d1f1318693ccf5cbbe46fa46dbf0bae1059069ca53e"
    sha256 cellar: :any_skip_relocation, mojave:        "f1f61f29fb6a6ce01843e7a484ae3e36e94b049d7f2da9ca1b2711887de046ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "48bffce8ba11ecb7d545b5f0a84718cb606f48fc693cc11511f229e64caf42f0"
  end

  depends_on "python@3.9"

  def install
    xy = Language::Python.major_minor_version "python3"
    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python#{xy}/site-packages"
    system "python3", *Language::Python.setup_install_args(libexec)

    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", PYTHONPATH: ENV["PYTHONPATH"])
  end

  test do
    (testpath/"Procfile").write("talk: echo $MY_VAR")
    (testpath/".env").write("MY_VAR=hi")
    assert_match(/talk\.\d+ \| hi/, shell_output("#{bin}/honcho start"))
  end
end
