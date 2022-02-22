class Dropboxignore < Formula
  desc "CLI tool for ignoring files in Dropbox"
  homepage "https://dropboxignore.simakis.me/"
  url "https://github.com/sp1thas/dropboxignore/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "033fa1ca2593489772ea3af97a665f5de4a1751fce6bb8b246322e8835cb402d"
  license "GPL-3.0-only"

  bottle do
    sha256 arm64_monterey: "24854522e2901befeb323be066c744ab4471920495b7a91280e9d05c9bc3b9e7"
    sha256 arm64_big_sur:  "e062925ce6b559649d5574f2ee4a709611df4a9a54f3396cf706c2a399cc747f"
    sha256 monterey:       "923df44c0bbcdcb70df775092fb6aacb3c7c4740a12d40ce6f5ad4a8dd7ea91f"
    sha256 big_sur:        "0c4b7d1c41dbd920e192711e8ed1200db46c30be141aaaeb606c41718d0c2a79"
    sha256 catalina:       "09e77aa3db2cf8a702effbebbbf83f7a2f860b0d5db6bcf37549edb7db5438a7"
    sha256 mojave:         "a6ab99c751a03e11e2ace660ad9325a9fe4262598f284c0fb87626778383e29d"
    sha256 high_sierra:    "a0461ecc678e5cb65a901bd39dbd7f0f8015a29ed605e6cf28f1315d5c347ecb"
    sha256 x86_64_linux:   "32ec309e47f9cc195c0bc8c9bccdf1169ff91e211991eeb1fb04d91872c3be51"
  end

  depends_on "diffutils"
  depends_on "grep"

  def install
    # Do not use 'make install' as it uses hardcoded destination
    bin.install "bin/dropboxignore.sh" => "dropboxignore"
  end

  test do
    assert_match "dropboxignore: v#{version}", shell_output("#{bin}/dropboxignore version")
  end
end
