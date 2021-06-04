class Deark < Formula
  desc "File conversion utility for older formats"
  homepage "https://entropymine.com/deark/"
  url "https://entropymine.com/deark/releases/deark-1.5.8.tar.gz"
  sha256 "8a8e23c7f744f7d1f3ea9ae4a034a204cac196a903db5c9657c00829fad7bb1c"
  license "MIT"

  livecheck do
    url "https://entropymine.com/deark/releases/"
    regex(/href=.*?deark[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "a907384f204e41ce39db43e23da0047c01a34d17a87e67d9d41ca5859807fb7a"
    sha256 cellar: :any_skip_relocation, big_sur:       "09ad8b8b146e4df4b0955be83fd168c842e47cb0f5dd94f5ce90df139a6a8831"
    sha256 cellar: :any_skip_relocation, catalina:      "e4416ed82488c439a1085bb9464abbbd082d6b85e350455c054f31b5978bb728"
    sha256 cellar: :any_skip_relocation, mojave:        "5667c9616961ca8b8da43979903aaac15a65a27f88bf4242327c2954fa1cb862"
  end

  def install
    system "make"
    bin.install "deark"
  end

  test do
    require "base64"

    (testpath/"test.gz").write ::Base64.decode64 <<~EOS
      H4sICKU51VoAA3Rlc3QudHh0APNIzcnJ11HwyM9NTSpKLVfkAgBuKJNJEQAAAA==
    EOS
    system "#{bin}/deark", "test.gz"
    file = (testpath/"output.000.test.txt").readlines.first
    assert_match "Hello, Homebrew!", file
  end
end
