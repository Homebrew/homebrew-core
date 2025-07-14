class Html2text < Formula
  desc "Advanced HTML-to-text converter"
  homepage "https://gitlab.com/grobian/html2text"
  url "https://github.com/grobian/html2text/releases/download/v2.3.0/html2text-2.3.0.tar.gz"
  sha256 "8cec23ed1ff43313f2d0e4b434cd39871bc002cad947a40d4a3738d1351921f7"
  license "GPL-2.0-or-later"
  head "https://gitlab.com/grobian/html2text.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e244711dd9a80f0a0086a6acece7436614c56cc3544b88b1586b1cc1a33476d3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1b1e778ff1bbacfa5f4bb389f16de755aca64924714c8f98fd7716edc95a5437"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4f0b879932edd63851fa7a2a23df5658da15364817757fdd610fc70e4eed9a28"
    sha256 cellar: :any_skip_relocation, sonoma:        "334b88e814046a9f15e87c2c986421c12f95d2a54465139f40579b3c92149d2a"
    sha256 cellar: :any_skip_relocation, ventura:       "f1eaecf6186bf7485709790034c6d882207a081382fd604994a16a4840e680b8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a7887dd659efb132d2bd8848b677e88140c5279d4b575f8597106299b02160c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6a4d92d0215bb31c12be4308ac756e49819218e05ff73bb0677514be9900c0ef"
  end

  def install
    ENV.cxx11
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    path = testpath/"index.html"
    path.write <<~HTML
      <!DOCTYPE html>
      <html>
        <head><title>Home</title></head>
        <body><p>Hello World</p></body>
      </html>
    HTML

    assert_equal "Hello World", shell_output("#{bin}/html2text #{path}").strip
  end
end
