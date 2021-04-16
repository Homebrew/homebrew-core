class Arturo < Formula
  desc "Simple, modern and portable programming language for efficient scripting"
  homepage "https://github.com/arturo-lang/arturo"
  url "https://github.com/arturo-lang/arturo/archive/v0.9.75.tar.gz"
  sha256 "ce63112fd8ff99d05df529fd96598d068f49b9253d65da3662e693cbb905147e"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "7379fd044433d4a3315868ce97a6c9b772ddb70394e3a9f8464b9e6015c5d08b"
    sha256 cellar: :any, big_sur:       "d122702a08e1b5d6e5c0251d0e38311bd6f40964659e9472366bc68fa662c888"
    sha256 cellar: :any, catalina:      "c5efd116535312d8d130bed4522be42fa796bd56c81f50f4ec334927b3e8fd9d"
    sha256 cellar: :any, mojave:        "33e9eabfcdcf5157c991163096eb844eb4f4212c63171e68da2cc110942cbf21"
  end

  depends_on "nim" => :build
  depends_on "gmp"
  depends_on "mysql"

  def install
    inreplace "install", "ROOT_DIR=\"$HOME/.arturo\"", "ROOT_DIR=\"#{prefix}\""
    system "./install"
  end

  test do
    (testpath/"hello.art").write <<~EOS
      print "hello"
    EOS
    assert_equal "hello", shell_output("#{bin}/arturo #{testpath}/hello.art").chomp
  end
end
