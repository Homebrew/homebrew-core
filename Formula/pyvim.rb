class Pyvim < Formula
  desc "Pure Python Vim clone"
  homepage "https://github.com/jonathanslenders/pyvim"
  url "https://files.pythonhosted.org/packages/96/3f/2fc173e4fec288adc9cd1dd52de15ca2a9947a941ee98d0ea3c678f89cd9/pyvim-2.0.22.tar.gz"
  sha256 "7534753a891d85fda859214e04e585371c61c1402157738be3904081a585369b"

  bottle do
    cellar :any_skip_relocation
    sha256 "f9770b97a7bed89fac287b7f07e8edf841d8917053d9e73abf2b54ab3f256676" => :mojave
    sha256 "dbbf3ac781e4717fcb8e7e607c6a7c2076b28a50324035b022ee119ed926cb43" => :high_sierra
    sha256 "dbbf3ac781e4717fcb8e7e607c6a7c2076b28a50324035b022ee119ed926cb43" => :sierra
    sha256 "dbbf3ac781e4717fcb8e7e607c6a7c2076b28a50324035b022ee119ed926cb43" => :el_capitan
  end

  depends_on "python@2"

  resource "docopt" do
    url "https://files.pythonhosted.org/packages/a2/55/8f8cab2afd404cf578136ef2cc5dfb50baa1761b68c9da1fb1e4eed343c9/docopt-0.6.2.tar.gz"
    sha256 "49b3a825280bd66b3aa83585ef59c4a8c82f2c8a522dbe754a8bc8d08c85c491"
  end

  resource "prompt_toolkit" do
    url "https://files.pythonhosted.org/packages/3e/36/d24222c4a44cb7b8d902db407e1918d8553c765b1384d78c7ea7a85b144c/prompt_toolkit-2.0.3.tar.gz"
    sha256 "d9ea14304a2633e4b40dde874c63da6b94a075f61e837011e035ffcd5bb39a1d"
  end

  resource "pyflakes" do
    url "https://files.pythonhosted.org/packages/92/9e/386c0d9deef14996eb90d9deebbcb9d3ceb70296840b09615cb61b2ae231/pyflakes-2.0.0.tar.gz"
    sha256 "9a7662ec724d0120012f6e29d6248ae3727d821bba522a0e6b356eff19126a49"
  end

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/71/2a/2e4e77803a8bd6408a2903340ac498cb0a2181811af7c9ec92cb70b0308a/Pygments-2.2.0.tar.gz"
    sha256 "dbae1046def0efb574852fab9e90209b23f556367b5a320c0bcb871c77c3e8cc"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/16/d8/bc6316cf98419719bd59c91742194c111b6f2e85abac88e496adefaf7afe/six-1.11.0.tar.gz"
    sha256 "70e8a77beed4562e7f14fe23a786b54f6296e34344c23bc42f07b15018ff98e9"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/55/11/e4a2bb08bb450fdbd42cc709dd40de4ed2c472cf0ccb9e64af22279c5495/wcwidth-0.1.7.tar.gz"
    sha256 "3df37372226d6e63e1b1e1eda15c594bca98a22d33a23832a90998faa96bc65e"
  end

  def install
    resources.each do |r|
      r.stage do
        system "python", *Language::Python.setup_install_args(libexec)
      end
    end

    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"
    system "python", *Language::Python.setup_install_args(libexec)
    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    # Need a pty due to https://github.com/jonathanslenders/pyvim/issues/101
    require "pty"
    PTY.spawn(bin/"pyvim", "--help") do |r, _w, _pid|
      assert_match "Vim clone", r.read
    end
  end
end
