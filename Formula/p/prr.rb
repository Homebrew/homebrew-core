class Prr < Formula
  desc "Mailing list style code reviews for github"
  homepage "https://github.com/danobi/prr"
  url "https://github.com/danobi/prr/archive/refs/tags/v0.8.2.tar.gz"
  sha256 "f155191fdf220b0dfe5f86ff8ad5cd042ad2ab6e152ae61f33cbd578517197de"
  license "GPL-2.0-only"
  head "https://github.com/danobi/prr.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "93f018bc6d898193286cb621c140513303c8a39e38cb67b0379b7a99ddedfa77"
    sha256 cellar: :any,                 arm64_ventura:  "1eb1d3b027d39cdea646245cd386eefd8ca131d1b3c915e6d3c9359ed81309c3"
    sha256 cellar: :any,                 arm64_monterey: "17ef9bed3912174f2ea77e5a4bddf1a2ea3bb459eb944161e959bcc1ba834756"
    sha256 cellar: :any,                 sonoma:         "38395e82d85d0ec5e0f7c755b5c396ce273cbe48f866dbb745f0e1812e796f1d"
    sha256 cellar: :any,                 ventura:        "25d75d538b13d4e2734f3ea6d35eb5c719f8b5f086957da390da8d9ac2880efb"
    sha256 cellar: :any,                 monterey:       "d92103489c15c6bc5df18d87c18b6274dfdbd56a715588e6a6f802a065b405ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6da94ed784fbd44ba3d7bedfecaef1fb4f1c5adfe9f3e2ce573d476d7f3b1373"
  end

  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "zlib"

  on_linux do
    depends_on "pkg-config" => :build
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "Failed to read config", shell_output("#{bin}/prr get Homebrew/homebrew-core/6 2>&1", 1)
  end
end
