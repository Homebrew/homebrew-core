class Html2text < Formula
  desc "Advanced HTML-to-text converter"
  homepage "https://gitlab.com/grobian/html2text"
  url "https://gitlab.com/-/project/48313341/uploads/8526650dd42218b3493ce7ca0a3eeb1e/html2text-2.4.0.tar.gz"
  sha256 "9d0a7174cacbb3f050b60facd8cba6e138944ec5020b16d1cee70cf91a59f132"
  license "GPL-2.0-or-later"
  head "https://gitlab.com/grobian/html2text.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9e719fed3a98611bfe8ca70a7b301f6f1a304a56e4f2d4b4dbfecab8ee0bd29a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bb724b272c288e009206280fe3371215d25cc67421a131b9dca6e7eafd01b28d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f4f030f29d12689fa0eaf0325f31497b468440aba2105ba7e07e70d758925dec"
    sha256 cellar: :any_skip_relocation, sonoma:        "455f23776916aae17d03e1eb7037fc8c513ca3649839248f00bd0110b41d9d65"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4a4a2f5b2a38d767681fdba41f5e8e2e5b8aa761cacde154c4b025af77be193f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "023827730941513938e30fbcd440c0ee215b76abb7a2ac194cb4a56b26dec816"
  end

  def install
    # libiconv is not linked properly without this
    ENV.append "LDFLAGS", "-liconv" if OS.mac?

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
