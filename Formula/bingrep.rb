class Bingrep < Formula
  desc "Greps through binaries from various OSs and architectures"
  homepage "https://github.com/m4b/bingrep"
  url "https://github.com/m4b/bingrep/archive/v0.9.1.tar.gz"
  sha256 "25db3c1d3e8c8dc9a41c6b87199f320c79b1a2706e8a4f68d2590fce71dabf8a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f5151f9b1fd95008aaa11974caab78ea7262ea1b33717310ce450e3121be7e0c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "77ed0815d04b29d3183adb7b17cca3fe9a5d3cab4f5292713e3e297bfa2e770c"
    sha256 cellar: :any_skip_relocation, monterey:       "2cb7058a166c4a754246634704a72b5810d43128f414e7a0bf09731d297e8944"
    sha256 cellar: :any_skip_relocation, big_sur:        "ee688ff6abecc9f34641de0c25b494fe799e221cb0b1c467955eb0a34688b28f"
    sha256 cellar: :any_skip_relocation, catalina:       "e0168bb41b7a5ae6e611402538c944f3b848e8594ad62c223425f8ee6ea22def"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4a9a46ff051a336c1141236e6b734489fae187c06dfe8db288142d95f088c92c"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"bingrep", bin/"bingrep"
  end
end
