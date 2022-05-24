class Fwup < Formula
  desc "Configurable embedded Linux firmware update creator and runner"
  homepage "https://github.com/fwup-home/fwup"
  url "https://github.com/fwup-home/fwup/releases/download/v1.9.0/fwup-1.9.0.tar.gz"
  sha256 "ea07aed5ff07678a687d047f99235fa2cd5d9527ed58c10bc87799dbf8833dff"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "26e1b69291adf061a94f66ce7dfe0cff208cd65d3dd5cb454d3edec9fc69712b"
    sha256 cellar: :any,                 arm64_big_sur:  "039c1d8567f456b54eef1d917894a0a7386e340b83db64e51581313a58ab28ae"
    sha256 cellar: :any,                 monterey:       "d6e4e53df468a5ea21534ee57b6f68e727039fb8aa54214b760713dd2ea4fab2"
    sha256 cellar: :any,                 big_sur:        "43e3411e8b6f05d7a1833a6c803dcc600e7d0947fd21c277676d193f474f2f50"
    sha256 cellar: :any,                 catalina:       "a1863740abd0c626c01da0d50cbd6e17b510861e61bd4fbef833df9dfaea6e08"
    sha256 cellar: :any,                 mojave:         "e95a285ad886fd4a6a305e49efac21b02d510e9bef7f8f50da25f44d4798bfce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "27dfa9a1c487e3f8d0d3331f3fceeac8771e5cbfe037da0cf80cd1ff3cdd4295"
  end

  depends_on "pkg-config" => :build
  depends_on "confuse"
  depends_on "libarchive"

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make", "install"
  end

  test do
    system bin/"fwup", "-g"
    assert_predicate testpath/"fwup-key.priv", :exist?, "Failed to create fwup-key.priv!"
    assert_predicate testpath/"fwup-key.pub", :exist?, "Failed to create fwup-key.pub!"
  end
end
