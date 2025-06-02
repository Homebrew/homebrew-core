class Deark < Formula
  desc "File conversion utility for older formats"
  homepage "https://entropymine.com/deark/"
  url "https://entropymine.com/deark/releases/deark-1.7.0.tar.gz"
  sha256 "7c3752c2c783cd6c4e22e527f1d72dbee9166883a156d25fbf98f73a8c44c8be"
  license "MIT"

  livecheck do
    url "https://entropymine.com/deark/releases/"
    regex(/href=.*?deark[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3f187e7332d8e5a0aa5e37bcd92428e3a67540169a447787e07105d91bded171"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8e0614b471960c3050b12098c9815a29da5238b8406bc72ddad21274f7bccd55"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "868b2f7a23d545977e5b68c3b7acb4e33ac1c9fe9a391d470c592799b5a5c6eb"
    sha256 cellar: :any_skip_relocation, sonoma:        "9a568c638ba0e2e84a40a82b9cdcd0fee3442b3da5e05f5b20677a785e515e55"
    sha256 cellar: :any_skip_relocation, ventura:       "b2914225b7ad22c0ccb2022c3a49431d8eee99c73882effe2200bbbfbbe2a3ad"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e993400488b4e8f3c36e0c84dcfc8affcf27edf212790004d66e3bf36ee7df9d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b00c25bc3f03a626a34e87c61993656345229bac72768bbe7503d5ec8ab7b5a7"
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
    system bin/"deark", "test.gz"
    file = (testpath/"output.000.test.txt").readlines.first
    assert_match "Hello, Homebrew!", file
  end
end
