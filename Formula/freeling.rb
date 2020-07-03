class Freeling < Formula
  desc "Suite of language analyzers"
  homepage "http://nlp.lsi.upc.edu/freeling/"
  url "https://github.com/TALP-UPC/FreeLing/archive/4.1.1.tar.gz"
  sha256 "c58822f262e6a9c550ce7dd080025aa322a0801b61aff10d5d085f8c168bee60"

  bottle do
    sha256 "a5500cffa2b4b1bdc057e43376ea5327d38866289cd44f6a89a60655223f6527" => :catalina
    sha256 "d708b3a477c5249b9f82f7e5636a6560ca8c9d32c893c1a541fcb29362f47b72" => :mojave
    sha256 "5e47503c307820eef22fdbb3d4f352e26296ae3476c09f0070e35f19b36fac55" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "icu4c"

  conflicts_with "hunspell", :because => "both install 'analyze' binary"

  # Fix linking with icu4c
  patch do
    url "https://github.com/TALP-UPC/FreeLing/commit/5e323a5f3c7d2858a6ebb45617291b8d4126cedb.patch?full_index=1"
    sha256 "0814211cd1fb9b075d370f10df71a4398bc93d64fd7f32ccba1e34fb4e6b7452"
  end

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end

    libexec.install "#{bin}/fl_initialize"
    inreplace "#{bin}/analyze",
      ". $(cd $(dirname $0) && echo $PWD)/fl_initialize",
      ". #{libexec}/fl_initialize"
  end

  test do
    expected = <<~EOS
      Hello hello NN 1
      world world NN 1
    EOS
    assert_equal expected, pipe_output("#{bin}/analyze -f #{pkgshare}/config/en.cfg", "Hello world").chomp
  end
end
