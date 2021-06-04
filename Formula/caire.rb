class Caire < Formula
  desc "Content aware image resize tool"
  homepage "https://github.com/esimov/caire"
  url "https://github.com/esimov/caire/archive/v1.3.2.tar.gz"
  sha256 "fe759bbbf4ddb2a89d43ac99812f8a3027e2f84fc8f9771db88ac043cc41cbf7"
  license "MIT"
  head "https://github.com/esimov/caire.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "99e369779abadd222e6d46031536c33f0097054633eae3e077f61eb5951a85cc"
    sha256 cellar: :any_skip_relocation, big_sur:       "fc1c2ff0a4e00e2fc4005515bd2720ecdd2abba2c0e36a0f2396d52a0ff127aa"
    sha256 cellar: :any_skip_relocation, catalina:      "869c6ff4fc5cabbc85b87f37afef6df1ea7fab98aaf98d779daf5e5c506b803f"
    sha256 cellar: :any_skip_relocation, mojave:        "22072fce690001b8cb981244ce84ce0f1c0aba0323e372cb992a8bc0b067aafa"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./cmd/caire"
  end

  test do
    system bin/"caire", "-in", test_fixtures("test.png"), "-out", testpath/"test_out.png",
           "-width=1", "-height=1", "-perc=1"
    assert_predicate testpath/"test_out.png", :exist?
  end
end
