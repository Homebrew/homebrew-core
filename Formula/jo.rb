class Jo < Formula
  desc "JSON output from a shell"
  homepage "https://github.com/jpmens/jo"
  url "https://github.com/jpmens/jo/releases/download/1.7/jo-1.7.tar.gz"
  sha256 "74c3032f0650bbaf69c17ef71ba3240e51262963843cdc8452d4e917ab8e8656"
  license all_of: ["GPL-2.0-or-later", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "03744513d271dfbb287fde4fb34c8f81e245d188601e7d71a94b96bff9f32b6e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c148c844d44ddc222336f10ae04c59526f1b06f9fe7744532d8b293c5391289c"
    sha256 cellar: :any_skip_relocation, monterey:       "2a65cc5d9bfdb238597506c9316cd1ef396e79d1629a5e9339a4d42035d5cd20"
    sha256 cellar: :any_skip_relocation, big_sur:        "57e2a4be4dbffaa00b9df1300668e95a509a0cdd383c7a7a0801b4102272b53c"
    sha256 cellar: :any_skip_relocation, catalina:       "9a7eb6fd999f8aa3d5f3357ff76a91ba3c92ec6ab8cbd321e8058a522c866d1d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d3b084f44800a84d3d2b150a9ee51246fb3601dbe88c9bb3ae1a4c73be660ecd"
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
