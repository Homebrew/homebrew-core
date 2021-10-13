class Honcho < Formula
  desc "Python clone of Foreman, for managing Procfile-based applications"
  homepage "https://github.com/nickstenning/honcho"
  url "https://files.pythonhosted.org/packages/a2/8b/c404bce050eba79a996f6901f35445a53c1133b0424b33e58a4ad225bc37/honcho-1.0.1.tar.gz"
  sha256 "c189402ad2e337777283c6a12d0f4f61dc6dd20c254c9a3a4af5087fc66cea6e"
  license "MIT"
  revision 4
  head "https://github.com/nickstenning/honcho.git"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "9f38c7840c832d8f40eb0c6f025357660e575c0281ccb76c5b123e33968efaca"
  end

  depends_on "python@3.10"

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
