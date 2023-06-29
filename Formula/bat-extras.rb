class BatExtras < Formula
  desc "Bash scripts that integrate bat with various command-line tools"
  homepage "https://github.com/eth-p/bat-extras"
  url "https://github.com/eth-p/bat-extras/archive/refs/tags/v2023.06.15.tar.gz"
  sha256 "8a4dbf5b09c11ce1ad605118c73cbf6635ec2b07b5723f9a02417ba10da1ef14"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c8e91eec17c5d0fce07c5b5a99ab65ff8928bbc660eb42db2060798d2488e7e0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1256043dbd483fe9ee7904c9815e760f4ea416f0b9f814e69be7ec5025a0ca05"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a7ee2d204e2b4ca87408e9aa9ca6ea9e610bca2cebfeb45f2403e0c694355411"
    sha256 cellar: :any_skip_relocation, ventura:        "d6cda9621a5b9edc1f8ae92858330212414038532d0a9059876d2529a2efedfd"
    sha256 cellar: :any_skip_relocation, monterey:       "52407df18f8ad9aa2241709b8492654223971e5c78a9560eb442bdd9edd5d18a"
    sha256 cellar: :any_skip_relocation, big_sur:        "f525b2a85e444856ce9eaabdcc53ede36a8a82a3e889e48b7746ae9eaa961f17"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4e4d50135be056aacb48b26bdfbd9daa468e4f8debf65d998ce0d38713975282"
  end

  depends_on "bat" => [:build, :test]
  depends_on "shfmt" => :build
  depends_on "ripgrep" => :test

  def install
    system "./build.sh", "--prefix=#{prefix}", "--minify", "all", "--install"
  end

  test do
    system "#{bin}/prettybat < /dev/null"
    system bin/"batgrep", "/usr/bin/env", bin
  end
end
