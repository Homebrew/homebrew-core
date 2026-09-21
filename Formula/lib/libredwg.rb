class Libredwg < Formula
  desc "DWG utilities"
  homepage "https://www.gnu.org/software/libredwg/"
  url "https://ftpmirror.gnu.org/libredwg/libredwg-0.14.tar.gz"
  sha256 "cb6ee0b078c6d9e0f09d66f1feac33ba6342df88ae544e9f9335fab475218351"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "52af574f09f32d0b027b86ae788c63bc7abbbd9c4fa60782db4e80a7cc9258b3"
    sha256 cellar: :any, arm64_tahoe:       "2e5efe7bb02a7067cd67e028da20b90a56d45fb126352d7d963de8ff8c6a2298"
    sha256 cellar: :any, arm64_sequoia:     "88669a054da909cb7af46735a28230457a623f24fe729e9ba638d49ae883850c"
    sha256 cellar: :any, arm64_sonoma:      "74a6c08fd39ff26029d8e5b784f878a8081602f7d5f3bb77f7df95849c5c89cd"
    sha256 cellar: :any, arm64_linux:       "278b4958a068dc54174990420d5ed0f496368f143559551e74332bb395182f65"
    sha256 cellar: :any, x86_64_linux:      "699b040982d5ba32013f54f09f13883b026c9c9c3bed42e56a8ef0a6193991fd"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkgconf" => :build
  depends_on "texinfo" => :build

  def install
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    resource "testdata" do
      url "https://github.com/LibreDWG/libredwg/raw/refs/heads/master/test/test-data/example_2000.dwg"
      sha256 "34574244d7556d1ef7b437443d9b3d1ad8662e1c669c42d80cff6a8a19799be9"
    end

    resource("testdata").stage do
      system bin/"dwgread", "-o", "example_2000.dxf", "example_2000.dwg"
      assert_path_exists "example_2000.dxf"
    end
  end
end
