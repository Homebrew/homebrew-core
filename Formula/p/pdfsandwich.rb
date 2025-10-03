class Pdfsandwich < Formula
  desc "Generate sandwich OCR PDFs from scanned file"
  homepage "http://www.tobias-elze.de/pdfsandwich/"
  url "https://downloads.sourceforge.net/project/pdfsandwich/pdfsandwich%200.1.7/pdfsandwich-0.1.7.tar.bz2"
  sha256 "9795ffea84b9b6b501f38d49a4620cf0469ddf15aac31bac6dbdc9ec1716fa39"
  license "GPL-2.0-or-later"
  revision 4
  head "https://svn.code.sf.net/p/pdfsandwich/code/trunk/src"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "16c76bd4f3d4fd4a22a1b23737aedd8d017cc0a51cc5aea380e6879b958184ed"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "8f02d04e6517c0a842df56f9e7e381a2c3520f20669507f9fe52412c462baa6d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0f7cd2c1676f390f9e5951408248c6b8d8682d4b70835ce67af1b89b2acefd74"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "93a40fb73e99c341323d434d2d03b7db027dd7b931aec4c2aed61f640f649b08"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a6af2fc71eb56e9f121e035b6348a1fa984989096a7158b963a84d5f7b92cc44"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9d03e5564d606b37f3b2aaa2dc68837ca023e87c455c9543836a854ec7728c4f"
    sha256 cellar: :any_skip_relocation, sonoma:         "b6530b56f5e6629c147e124dc31f70d2632903681bcfcd23368bafcfc11531a8"
    sha256 cellar: :any_skip_relocation, ventura:        "83ad92b56bb7f058c816fa8a0fbd78b382f709ff69b42e5ae7684e98d811e2b8"
    sha256 cellar: :any_skip_relocation, monterey:       "d008b33e11a652bfd5e130f09aa7138fa599b22b4b48db266457aa1ceec17361"
    sha256 cellar: :any_skip_relocation, big_sur:        "eed36d608adf9c4c6a7bcfa2f8d51fc7d7db6b9625d8dd87420b0a49432ed099"
    sha256 cellar: :any_skip_relocation, catalina:       "e45ad2480a96ef2ff2ee1a0a561004510d3d3f2b61117fce51d2995b5a004b34"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "38e8f84c9d73b6ee9caa30ecdc46eca87ad44042d0b2afd212ade6b04711fe9b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6f77d1aa373059a0b32d879bc45f075527a28c6a0a2068b8d38d634dfd2d7d60"
  end

  depends_on "gawk" => :build
  depends_on "ocaml" => :build
  depends_on "exact-image"
  depends_on "ghostscript"
  depends_on "imagemagick"
  depends_on "poppler"
  depends_on "tesseract"
  depends_on "unpaper"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
    bin.env_script_all_files(libexec/"bin", PATH: "#{Formula["poppler"].opt_bin}:$PATH")
  end

  test do
    system bin/"pdfsandwich", "-o", testpath/"test_ocr.pdf",
           test_fixtures("test.pdf")
    assert_path_exists testpath/"test_ocr.pdf", "Failed to create ocr file"
  end
end
