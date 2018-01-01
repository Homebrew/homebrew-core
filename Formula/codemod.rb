class Codemod < Formula
  desc "Large-scale codebase refactors assistant tool"
  homepage "https://github.com/facebook/codemod"
  url "https://files.pythonhosted.org/packages/9b/e3/cb31bfcf14f976060ea7b7f34135ebc796cde65eba923f6a0c4b71f15cc2/codemod-1.0.0.tar.gz"
  sha256 "06e8c75f2b45210dd8270e30a6a88ae464b39abd6d0cab58a3d7bfd1c094e588"
  version_scheme 1

  head "https://github.com/facebook/codemod.git"

  bottle :unneeded

  depends_on "python" if MacOS.version <= :snow_leopard

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"
    system "python", *Language::Python.setup_install_args(libexec)
    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    # work around some codemod terminal bugs
    ENV["TERM"] = "xterm"
    ENV["LINES"] = "25"
    ENV["COLUMNS"] = "80"
    (testpath/"file1").write <<~EOS
      foo
      bar
      potato
      baz
    EOS
    (testpath/"file2").write <<~EOS
      eeny potato meeny miny moe
    EOS
    system bin/"codemod", "--include-extensionless", "--accept-all", "potato", "pineapple"
    assert_equal %w[foo bar pineapple baz], File.read("file1").lines.map(&:strip)
    assert_equal ["eeny pineapple meeny miny moe"], File.read("file2").lines.map(&:strip)
  end
end
