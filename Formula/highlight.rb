class Highlight < Formula
  desc "Convert source code to formatted text with syntax highlighting"
  homepage "http://www.andre-simon.de/doku/highlight/en/highlight.php"
  url "http://www.andre-simon.de/zip/highlight-3.47.tar.bz2"
  sha256 "cec440d4a5e56d371009c45baeb19caa9040c97b52916b7a29ddd2520e722d76"
  head "https://gitlab.com/saalen/highlight.git"

  bottle do
    sha256 "75fd94388aeb276ced3d627159a4d807db241fa088de362e1ead07bcb878b3ed" => :mojave
    sha256 "1f5b6d789ee42f132f3387da7a459396315b03ad64fa0726a8faa3094f72e616" => :high_sierra
    sha256 "2e1fbf7d14c171f487e8b00b649014ada94e9149e9cbaa68d917d5475f9eccee" => :sierra
  end

  depends_on "boost" => :build
  depends_on "pkg-config" => :build
  depends_on "lua"

  def install
    conf_dir = etc/"highlight/" # highlight needs a final / for conf_dir
    system "make", "PREFIX=#{prefix}", "conf_dir=#{conf_dir}"
    system "make", "PREFIX=#{prefix}", "conf_dir=#{conf_dir}", "install"
  end

  test do
    system bin/"highlight", doc/"extras/highlight_pipe.php"
  end
end
