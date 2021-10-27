class Dssim < Formula
  desc "RGBA Structural Similarity Rust implementation"
  homepage "https://github.com/kornelski/dssim"
  url "https://github.com/kornelski/dssim/archive/3.1.0.tar.gz"
  sha256 "32ee74086a743eaf9dfde8b3cf83bd7165c06adc563d32541341b0cf79b2e58d"
  license "AGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f01d40a4d82e2c676243ad831cdd7086ce456962ca52e0df73892b2a8fad4695"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "664834c24f8facd8540cdce6284bd9e978ab5a06a2bc84ffd7ece97cb74fc4fd"
    sha256 cellar: :any_skip_relocation, monterey:       "da5499520643a7f7ebf4287b9ba3b0552f5216fc2f5aa5dfed9659472124774e"
    sha256 cellar: :any_skip_relocation, big_sur:        "30fb8ac36dbfb09df6482d9e396108d6570ffea6aa72abce8a290dcc3e1b8b33"
    sha256 cellar: :any_skip_relocation, catalina:       "b87f31b0fecae87122840dc0390114087c6cf55d1e1117f57860a4eb5fa052bb"
    sha256 cellar: :any_skip_relocation, mojave:         "f98d8778ae6fffbac0c30aaf5e9062a19c507b2c71fe40fc2e3aeef4df970784"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "92200df875cc2bc4347dabd67e547e94eb9e467205bc73b18920ea23ae6c5b01"
  end

  depends_on "nasm" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system "#{bin}/dssim", test_fixtures("test.png"), test_fixtures("test.png")
  end
end
