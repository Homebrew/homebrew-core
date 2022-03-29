class Janet < Formula
  desc "Dynamic language and bytecode vm"
  homepage "https://janet-lang.org"
  url "https://github.com/janet-lang/janet/archive/v1.21.1.tar.gz"
  sha256 "8c6eeabbc0c00ac901b66763676fa4bfdac96e5b6a3def85025b45126227c4e0"
  license "MIT"
  head "https://github.com/janet-lang/janet.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "8bdce7f46de0375dc5a9a817b0449699490ecde8631b4f5d5d552c25ec6621c6"
    sha256 cellar: :any,                 arm64_big_sur:  "bc919064dee1e9b5816a1b6d5b7f4037854412168dbd5642257f1ed215732d6b"
    sha256 cellar: :any,                 monterey:       "22de64829c404fb10852ca762730813c07332670f3226f386b744122e3ed3723"
    sha256 cellar: :any,                 big_sur:        "7933b0a60adafa53f651c830646d8116bb6e63ba460402171dbc931217ea8744"
    sha256 cellar: :any,                 catalina:       "4b55eb7746f8999332597282df15b36502165b16555d63ffd70d24177d298834"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cd5dc3513e62fb9fc279f3f433145c7adbfd881203796f1c822d661a3c45832b"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build

  def install
    system "meson", "setup", "build", *std_meson_args
    cd "build" do
      system "ninja"
      system "ninja", "install"
    end
  end

  test do
    assert_equal "12", shell_output("#{bin}/janet -e '(print (+ 5 7))'").strip
  end
end
