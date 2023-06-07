class Fwup < Formula
  desc "Configurable embedded Linux firmware update creator and runner"
  homepage "https://github.com/fwup-home/fwup"
  url "https://github.com/fwup-home/fwup/releases/download/v1.10.0/fwup-1.10.0.tar.gz"
  sha256 "021c51fdd3b759dfd48b4e415c00f6c6cb697f2ba3224833dff814d5b6e71dff"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "7248797a54c55b0376b99d1868be5d1c226859265505c4d83787a20aa8ddd983"
    sha256 cellar: :any,                 arm64_monterey: "bb2828960ada73afaf85c9036fbf7fae9ae867fe6dc78c8976109c41d50a2e7f"
    sha256 cellar: :any,                 arm64_big_sur:  "c0e916e8849e010ff8493fa30b3c138fa5a94b7b6d343d0fae5cf828b9d7c72f"
    sha256 cellar: :any,                 ventura:        "dd6eaf904507d491e8f2660413231d768e42afd1433c65eee9662d41016160eb"
    sha256 cellar: :any,                 monterey:       "61523d4932c6ecb6fbb0923860c180ebab1b97559c35f69cc8b6fcd3ffd33365"
    sha256 cellar: :any,                 big_sur:        "763e4158eff439c676cfcc547332180d1459218b5603a980b6aa7fe56b1fa754"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7bb86b4fa293a8eea0e545a66aed3f7d40348e36c3e75d5aad6d430071e05084"
  end

  depends_on "pkg-config" => :build
  depends_on "confuse"
  depends_on "libarchive"

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make", "install"
  end

  test do
    system bin/"fwup", "-g"
    assert_predicate testpath/"fwup-key.priv", :exist?, "Failed to create fwup-key.priv!"
    assert_predicate testpath/"fwup-key.pub", :exist?, "Failed to create fwup-key.pub!"
  end
end
