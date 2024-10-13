class Mandown < Formula
  desc "Man-page inspired Markdown viewer"
  homepage "https://github.com/Titor8115/mandown"
  url "https://github.com/Titor8115/mandown/archive/refs/tags/v1.0.4.tar.gz"
  sha256 "dc719e6a28a4585fe89458eb8c810140ed5175512b089b4815b3dda6a954ce3e"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_sequoia:  "729bf8e294a1ad8f1f18a4555cf370cf6969e55b7fcf0abbafe1665422397ffc"
    sha256 cellar: :any, arm64_sonoma:   "77a810adcb13125cce9d5a965a9e2a81f7f8fb025ee35bbfeb5f8975f50dabbe"
    sha256 cellar: :any, arm64_ventura:  "8f38c697d7d7fff6d1de02483bbf49b3dcf3b65e127047fbc2a9b84228657a28"
    sha256 cellar: :any, arm64_monterey: "cc29dc5580e538cac4010354481a5e9081e90735583380c99bd070e612c8c7bf"
    sha256 cellar: :any, arm64_big_sur:  "ade14b3cea59db3e21e4ee249f877ae6fb634100d78c62fbba62ce541a2a5562"
    sha256 cellar: :any, sonoma:         "906c662c4be28c0ab41bb4fc22d2b80372f20d890c504903e723c21ef7d038e4"
    sha256 cellar: :any, ventura:        "09b8c52b987c8d1eb510c75c9d395a62d1a69eb66f483e32c10728cc51beb8a0"
    sha256 cellar: :any, monterey:       "b13a81a1680806978c759cd0f2eb8b8e6d155818ac88456b9bc2ed24fdcf903e"
    sha256 cellar: :any, big_sur:        "6cd1c1d88d93223b889eecd77b5e278dc59f9de445b7a08eb7d41c7152db6b6d"
  end

  depends_on "pkg-config" => :build
  depends_on "libconfig"
  uses_from_macos "libxml2"
  uses_from_macos "ncurses"

  def install
    system "make", "install", "PREFIX=#{prefix}", "PKG_CONFIG=pkg-config"
  end

  test do
    (testpath/".config/mdn").mkpath # `mdn` may misbehave when its config directory is missing.
    (testpath/"test.md").write <<~EOS
      # Hi from readme file!
    EOS
    expected_output = <<~EOS
      <html><head><title>test.md(7)</title></head><body><h1>Hi from readme file!</h1>
      </body></html>
    EOS
    system bin/"mdn", "-f", "test.md", "-o", "test"
    assert_equal expected_output, File.read("test")
  end
end
