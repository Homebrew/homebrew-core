class Plutoprint < Formula
  include Language::Python::Virtualenv

  desc "Generate PDFs and Images from HTML"
  homepage "https://github.com/plutoprint/plutoprint"
  url "https://files.pythonhosted.org/packages/ef/d0/af1b23123d37d1f672dbf5d68cf33b1ad1e274936079d33118ae9e18ce47/plutoprint-0.12.0.tar.gz"
  sha256 "cbca7d1f2bc1c61c14c3feb9ab16b54583cfaa350ec8266de879940494e7dbe1"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "51d74f165529178d75073de7ac6e9e724337ee5a3745e8ec2d01189b187196c8"
    sha256 cellar: :any,                 arm64_sequoia: "1ca288bd85da025d0067ee3c3bc08a6e909696bfa0e92408b2edb37a362a9c1d"
    sha256 cellar: :any,                 arm64_sonoma:  "10c68efbdc3d8b4f195e5695d21e1d650b9e600406dbf6c5d196652f231b9979"
    sha256 cellar: :any,                 sonoma:        "e714602f0a380e8a163962fcdad2930cf316ddaf717ee72f4c715268f5b97f6d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ebd801aadbab3e675dbfdab5b2d3b9293bbc1a7f9afade0c2370ad50ab4ccd8e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "704746c55f3ad1874a3d56edfd3f417c1aa531ca961aae3ccb336fa7da7e2b09"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "plutobook"
  depends_on "python@3.13"

  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version <= 1499
  end

  on_ventura do
    depends_on "llvm" => :build
  end

  on_linux do
    depends_on "patchelf" => :build
  end

  fails_with :clang do
    build 1499
    cause "Requires C++20 support"
  end

  fails_with :gcc do
    version "9"
    cause "requires GCC 10+"
  end

  def python3
    "python3.13"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/plutoprint --version")

    (testpath/"test.html").write <<~HTML
      <h1>Hello World!</h1>
    HTML

    system bin/"plutoprint", "test.html", "test.pdf"
    assert_path_exists testpath/"test.pdf"
  end
end
