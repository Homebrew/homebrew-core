class Plutoprint < Formula
  include Language::Python::Virtualenv

  desc "Generate PDFs and Images from HTML"
  homepage "https://github.com/plutoprint/plutoprint"
  url "https://files.pythonhosted.org/packages/46/2d/7467cfaa2206eb3acf69adec70f1b51da6f406ac7ac0d5703dd34bcb1374/plutoprint-0.10.0.tar.gz"
  sha256 "802671eb74521ae97690f25cfb5038ed25db67cfafa12b0b9725f117df651dc9"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "39d7e6236e8fab5b83d58f24874d508823e27738501e655f3f734adc362d35b2"
    sha256 cellar: :any,                 arm64_sequoia: "2e5fe4a2e39568447835f6101bfac77dd0484bee2d07c8ba3069fc1c7e24338b"
    sha256 cellar: :any,                 arm64_sonoma:  "39d677acbdbfa3748a998038dfd685579644866de6dfdcbb37827425ba4b677e"
    sha256 cellar: :any,                 arm64_ventura: "fbdbdade14cd1893a1e19f4cfcd2d4d3c63407ed0aa084d22f31bcfeb657438f"
    sha256 cellar: :any,                 sonoma:        "b7c69ad3c87e039b98ea404a14e19cb3f690cb048908d3a419417a609ada49eb"
    sha256 cellar: :any,                 ventura:       "85249d0f7291845c500e34ecd8d243c06917f386896f4474bda7f1aea67a768d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a1a16bae9ac0ce8d59c90b52a1986610adbac3e59c5ea5b469b3c416d906596a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "632dda7e183febcd6f936733e2c495409b30e385aa7bce91b3714037c7dc4f22"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "plutobook"
  depends_on "python@3.13"

  on_macos do
    depends_on "llvm" if DevelopmentTools.clang_build_version <= 1499
  end

  on_ventura do
    depends_on "llvm"
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
    if OS.mac? && (MacOS.version == :ventura || DevelopmentTools.clang_build_version <= 1499)
      ENV.llvm_clang
      llvm = Formula["llvm"]
      ENV.append "LDFLAGS", "-L#{llvm.opt_lib}/c++ -L#{llvm.opt_lib}/unwind -lunwind"
    end

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
