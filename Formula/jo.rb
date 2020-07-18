class Jo < Formula
  desc "JSON output from a shell"
  homepage "https://github.com/jpmens/jo"
  url "https://github.com/jpmens/jo/releases/download/1.4/jo-1.4.tar.gz"
  sha256 "24c64d2eb863900947f58f32b502c95fec8f086105fd31151b91f54b7b5256a2"

  bottle do
    cellar :any_skip_relocation
    sha256 "7bbe7df2da77374b644e9909da0bbd356a8e8b2bbc49addf5593c2ee783c69e6" => :catalina
    sha256 "3003ca4f6f3650f6f67be5e4debadfb50d9e55ba41f792b9c37eaeb78a6241ab" => :mojave
    sha256 "ca189874bb16f024bc804fb167da2a8cfd0839fddd415aae964ee27ac112ba43" => :high_sierra
  end

  head do
    url "https://github.com/jpmens/jo.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  def install
    system "autoreconf", "-i" if build.head?

    system "./configure", "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_equal %Q({"success":true,"result":"pass"}\n), pipe_output("#{bin}/jo success=true result=pass")
  end
end
