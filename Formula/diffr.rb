class Diffr < Formula
  desc "LCS based diff highlighting tool to ease code review from your terminal"
  homepage "https://github.com/mookid/diffr"
  url "https://github.com/mookid/diffr/archive/v0.1.4.tar.gz"
  sha256 "2613b57778df4466a20349ef10b9e022d0017b4aee9a47fb07e78779f444f8cb"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "16b576c6910c6f6237afe36982863c7983311f7e00fe3839c60836acf4d99390"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f57876703b78ba621df49fee7ffa47bcd31653d8ce0b3e1a63a7e5a6b71bfac1"
    sha256 cellar: :any_skip_relocation, monterey:       "e7237f17610b659e423f5296c7d0796c375f66af4613c1e611da2a439fa07d9b"
    sha256 cellar: :any_skip_relocation, big_sur:        "a15c72a899fc35a31c7ec0915788ef48a321e75cb2aab2a25d46f71876bf767d"
    sha256 cellar: :any_skip_relocation, catalina:       "95c977ef5f56699e0007be2b869e12007afec6fabdd84b003825e04e66d52d74"
    sha256 cellar: :any_skip_relocation, mojave:         "b3d54c3e09b5b8a5a6de7b1d8c4511b4ff1d0b835250738343a45e3e872a0d08"
    sha256 cellar: :any_skip_relocation, high_sierra:    "4b0ac077f6fd419d00c67dbfa100b8822dc041a8b12925cbda7a4d87a2c470fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "172f1672ee5047a32348bfb77e4d13b49681531ee2adeede6deaaade107f61ff"
  end

  depends_on "rust" => :build
  depends_on "diffutils" => :test

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"a").write "foo"
    (testpath/"b").write "foo"
    _output, status =
      Open3.capture2("#{Formula["diffutils"].bin}/diff -u a b | #{bin}/diffr")
    status.exitstatus.zero?
  end
end
