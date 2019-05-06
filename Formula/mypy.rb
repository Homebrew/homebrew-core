class Mypy < Formula
  desc "Experimental optional static type checker for Python"
  homepage "http://www.mypy-lang.org/"
  url "https://github.com/python/mypy.git",
      :tag      => "v0.701",
      :revision => "7aaa435063f7bb81019740f0b56be359374b02fc"
  head "https://github.com/python/mypy.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "fd31c472e936c229c76e270016fff0c0636af847bde90f20f4ab5c2f54d49796" => :mojave
    sha256 "f9d71d7e5360a7dbe5947d0938035940976bb0e0c7330b8d2774b4b72812a4e0" => :high_sierra
    sha256 "1d8cfeae606c3ae6548b45a43fbea0fc1e4b9068a028a7336c1a6322b686587a" => :sierra
  end

  depends_on "sphinx-doc" => :build
  depends_on "python"

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/51/9e/0f8f5423ce28c9109807024f7bdde776ed0b1161de20b408875de7e030c3/psutil-5.4.6.tar.gz"
    sha256 "686e5a35fe4c0acc25f3466c32e716f2d498aaae7b7edc03e2305b682226bcf6"
  end

  resource "sphinx_rtd_theme" do
    url "https://files.pythonhosted.org/packages/1c/f2/a1361e5f399e0b4182d031065eececa63ddb8c19a0616b03f119c4d5b6b4/sphinx_rtd_theme-0.4.0.tar.gz"
    sha256 "de88d637a60371d4f923e06b79c4ba260490c57d2ab5a8316942ab5d9a6ce1bf"
  end

  resource "typed-ast" do
    url "https://files.pythonhosted.org/packages/a6/4e/ff9d7b7091e2308d2cdb04a1a317e13f293f4408990ee4a52b7028657917/typed-ast-1.3.4.tar.gz"
    sha256 "68c362848d9fb71d3c3e5f43c09974a0ae319144634e7a47db62f0f2a54a7fa7"
  end

  resource "mypy_extensions" do
    url "https://files.pythonhosted.org/packages/c2/92/3cc05d1206237d54db7b2565a58080a909445330b4f90a6436302a49f0f8/mypy_extensions-0.4.1.tar.gz"
    sha256 "37e0e956f41369209a3d5f34580150bcacfabaa57b33a15c0b25f4b5725e0812"
  end

  def install
    xy = Language::Python.major_minor_version "python3"

    # https://github.com/python/mypy/issues/2593
    version_static = buildpath/"mypy/version_static.py"
    version_static.write "__version__ = '#{version}'\n"
    inreplace "docs/source/conf.py", "mypy.version", "mypy.version_static"

    (buildpath/"docs/sphinx_rtd_theme").install resource("sphinx_rtd_theme")
    # Inject sphinx_rtd_theme's path into sys.path
    inreplace "docs/source/conf.py",
              "sys.path.insert(0, os.path.abspath('../..'))",
              "sys.path[:0] = [os.path.abspath('../..'), os.path.abspath('../sphinx_rtd_theme')]"
    system "make", "-C", "docs", "html"
    doc.install Dir["docs/build/html/*"]

    rm version_static

    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python#{xy}/site-packages"
    resources.each do |r|
      r.stage do
        system "python3", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python#{xy}/site-packages"
    system "python3", *Language::Python.setup_install_args(libexec)

    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    (testpath/"broken.py").write <<~EOS
      def p() -> None:
        print('hello')
      a = p()
    EOS
    output = pipe_output("#{bin}/mypy broken.py 2>&1")
    assert_match '"p" does not return a value', output
  end
end
