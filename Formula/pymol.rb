class Pymol < Formula
  include Language::Python::Virtualenv
  desc "Molecular visualization system"
  homepage "https://pymol.org/"
  url "https://github.com/schrodinger/pymol-open-source/archive/v2.5.0.tar.gz"
  sha256 "aa828bf5719bd9a14510118a93182a6e0cadc03a574ba1e327e1e9780a0e80b3"
  license :cannot_represent
  head "https://github.com/schrodinger/pymol-open-source.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "442a19b90c0c409a6e28b1a5109d1488eaf32517af39a4581990376dcbc29e8d"
    sha256 cellar: :any,                 arm64_big_sur:  "d8c8ce1d39303aae9ca9164d66ffce27a2ee630fd5d87207798d9cbf8e698c1f"
    sha256 cellar: :any,                 monterey:       "28739ca1c31b44f22d62f2d1becd25f0abc0e3712d935756283e6d5f9a2bb8ba"
    sha256 cellar: :any,                 big_sur:        "1ba261d75ec797e5ab4e391e03ed55c3c646c5e12eb90f873efdc01901ba0601"
    sha256 cellar: :any,                 catalina:       "c09b40643c84b35d008c3a7295c29ccc69a3fd4fd4a215d501965b856e944ff5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ed879a85c2e20f8f31a8079676aa8e3f3d05a57e0a0a7355cd6d731158d41ae1"
  end

  depends_on "cmake" => :build
  depends_on "glm" => :build
  depends_on "msgpack-cxx" => :build
  depends_on "sip" => :build
  depends_on "freetype"
  depends_on "glew"
  depends_on "libpng"
  depends_on "netcdf"
  depends_on "numpy"
  depends_on "pyqt@5"
  depends_on "python@3.10"
  uses_from_macos "libxml2"

  on_linux do
    depends_on "freeglut"
  end

  resource "mmtf-cpp" do
    url "https://github.com/rcsb/mmtf-cpp/archive/refs/tags/v1.0.0.tar.gz"
    sha256 "881f69c4bb56605fa63fd5ca50842facc4947f686cbf678ad04930674d714f40"
  end

  resource "msgpack" do
    url "https://files.pythonhosted.org/packages/61/3c/2206f39880d38ca7ad8ac1b28d2d5ca81632d163b2d68ef90e46409ca057/msgpack-1.0.3.tar.gz"
    sha256 "51fdc7fb93615286428ee7758cecc2f374d5ff363bdd884c7ea622a7a327a81e"
  end

  resource "mmtf-python" do
    url "https://files.pythonhosted.org/packages/13/ea/c6a302ccdfdcc1ab200bd2b7561e574329055d2974b1fb7939a7aa374da3/mmtf-python-1.1.2.tar.gz"
    sha256 "a5caa7fcd2c1eaa16638b5b1da2d3276cbd3ed3513f0c2322957912003b6a8df"
  end

  resource "Pmw" do
    url "https://github.com/schrodinger/pmw-patched/archive/8bedfc8747e7757c1048bc5e11899d1163717a43.tar.gz"
    sha256 "3a59e6d33857733d0a8ff0c968140b8728f8e27aaa51306160ae6ab13cea26d3"
  end

  def python3
    which("python3.10")
  end

  def install
    site_packages = Language::Python.site_packages(python3)
    ENV.prepend_path "PYTHONPATH", Formula["numpy"].opt_prefix/site_packages

    resource("mmtf-cpp").stage do
      system "cmake", "-S", ".", "-B", "build", *std_cmake_args(install_prefix: buildpath/"mmtf")
      system "cmake", "--build", "build"
      system "cmake", "--install", "build"
    end

    # install other resources
    resources.each do |r|
      next if r.name == "mmtf-cpp"

      r.stage do
        system python3, *Language::Python.setup_install_args(libexec, python3)
      end
    end

    if OS.linux?
      # Fixes "libxml/xmlwriter.h not found" on Linux
      ENV.append "LDFLAGS", "-L#{Formula["libxml2"].opt_lib}"
      ENV.append "CPPFLAGS", "-I#{Formula["libxml2"].opt_include}/libxml2"
    end
    # CPPFLAGS freetype2 required.
    ENV.append "CPPFLAGS", "-I#{Formula["freetype"].opt_include}/freetype2"
    # Point to vendored mmtf headers.
    ENV.append "CPPFLAGS", "-I#{buildpath}/mmtf/include"

    args = %W[
      --install-scripts=#{libexec}/bin
      --install-lib=#{libexec/site_packages}
      --glut
      --use-msgpackc=c++11
    ]

    system python3, "setup.py", "install", *args
    (prefix/site_packages/"homebrew-pymol.pth").write libexec/site_packages
    bin.install libexec/"bin/pymol"
  end

  def caveats
    "To generate movies, run `brew install ffmpeg`."
  end

  test do
    (testpath/"test.py").write <<~EOS
      from pymol import cmd
      cmd.fragment('ala')
      cmd.zoom()
      cmd.png("test.png", 200, 200)
    EOS
    system "#{bin}/pymol", "-cq", testpath/"test.py"
    assert_predicate testpath/"test.png", :exist?, "Amino acid image should exist"
    system python3, "-c", "import pymol"
  end
end
