class Gif2png < Formula
  desc "Convert GIFs to PNGs"
  homepage "http://www.catb.org/~esr/gif2png/"

  # Use canonical URL http://www.catb.org/~esr/gif2png/gif2png-<version>.tar.gz instead
  # once it starts to include go.mod/go.sum
  # See https://gitlab.com/esr/gif2png/-/issues/14#note_1373069233.
  url "https://gitlab.com/esr/gif2png/-/archive/3.0.3/gif2png-3.0.3.tar.bz2"
  sha256 "5d2770dce994e08ef54871ea4b0774e0ec0476aad5b3e47e21b4af59fdc8158b"
  license "BSD-2-Clause"
  head "https://gitlab.com/esr/gif2png.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?gif2png[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "9ffa76192c9c581c3fd4aa8d8f56da708f1799dc9122379b34d1ad9240d937ba"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "7ba18868f7931d35e5ea59235cd76fdda07273197bd933f070b5f569691cbad2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c6e8176b235912541139f6cc30de30486df4685e4cda1510a13ccd46e5de1467"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ad9c25896465c88ac69a9842d32a4bfe0c27610231cccb44edec51849c626bbd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "59ac954d69ee7aaced44921cea98f2127a6c7e3c07b4b5137547e5bd0821ffb0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6ee7f033d2587da8ef2bea8b06ae06490e883b2d940f5c4c384785dc6cc2cd08"
    sha256 cellar: :any_skip_relocation, sonoma:         "04f52349c694e66c677fead8de900d73b1085f7e39bf93dc6fe3cb6740ae43ff"
    sha256 cellar: :any_skip_relocation, ventura:        "9f4ba17bffa9f388b4121f66eb11ae7d615a8634f0f9ddf823daebdb15e3e1a0"
    sha256 cellar: :any_skip_relocation, monterey:       "81ed68b6098478c4bd432fa2282ae2bf918363c6886fca15da570dece203d492"
    sha256 cellar: :any_skip_relocation, big_sur:        "647072adee889c3a129dc904532132340e5cee323dc657997879fe8331d5d1b6"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "931ff3541cbae346953c4469ba2f229f1f1e3b2e08d9cf7b3499b94675472de5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "edb1fd446d42cc045ece44370a4e99d62f18862a66a6e95d4ff2718cdeeffb5e"
  end

  depends_on "go" => :build
  depends_on "xmlto" => :build

  uses_from_macos "python" # for web2png

  def install
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"

    system "make", "install", "prefix=#{prefix}"
  end

  test do
    pipe_output "#{bin}/gif2png -O", File.read(test_fixtures("test.gif"))
  end
end
