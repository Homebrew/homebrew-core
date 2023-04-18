class Ired < Formula
  desc "Minimalistic hexadecimal editor designed to be used in scripts"
  homepage "https://github.com/radare/ired"
  url "https://github.com/radare/ired/archive/0.6.tar.gz"
  sha256 "c15d37b96b1a25c44435d824bd7ef1f9aea9dc191be14c78b689d3156312d58a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2b152332ff671a52b4025c50746e88f84d91794e2fe433a9fddaddd10382b0cc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "beaab59e24217daae0d860b303cbd4d75649509805cf1dff0d38de222d2e66ec"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8c5fc028d62ce70b95c2f4ae6e9ec78c88b1083d7244263e5cae2734f9f1f682"
    sha256 cellar: :any_skip_relocation, ventura:        "b4ebac315972d619eb8034bd5b486a6e4e8c46e9bc7ca4aff78a5e7a19c62af4"
    sha256 cellar: :any_skip_relocation, monterey:       "6f988d4fafb5fc0070801f09feb033b469a8c4463a87ff3abb2e6b081b4c1a62"
    sha256 cellar: :any_skip_relocation, big_sur:        "383839a113477cfad0b9197aa5e1e5c07ca5248057da840617354552ea35e6dc"
    sha256 cellar: :any_skip_relocation, catalina:       "e74475e811c38aa46bf3e7e69e0a264a2d30c08cfcbd801433e03c14944b8366"
    sha256 cellar: :any_skip_relocation, mojave:         "7821d818af4c7d28b4cbf26c627685b77f18a1004369d4a57bee2582620008b7"
    sha256 cellar: :any_skip_relocation, high_sierra:    "f6af714455a74c02769c9726855a92832e43c37c79a0c589a0c7744beac8956c"
    sha256 cellar: :any_skip_relocation, sierra:         "5d10dfac87e4a4ca589a9fa76e8f9aff62625ef6358b6ab29360e79fe4a6dc35"
    sha256 cellar: :any_skip_relocation, el_capitan:     "4fc558225913b629b144661385841e63ebb167beb9900475fadb0c0e886b4997"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f3ddb4735af8b485b31fb3c9b2b8cc87c0aadfd1c3a2ae43df84bee8d5f16701"
  end

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    input = <<~EOS
      w"hello wurld"
      s+7
      r-4
      w"orld"
      q
    EOS
    pipe_output("#{bin}/ired test.text", input)
    assert_equal "hello world", (testpath/"test.text").read.chomp
  end
end
