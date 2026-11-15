class Pie < Formula
  desc "PHP Installer for Extensions"
  homepage "https://github.com/php/pie"
  url "https://github.com/php/pie/releases/download/1.5.5/pie.phar"
  sha256 "2ca0dff6868f1b53c095625674deef38ac698588e0a25e4321cd834a5b7553bc"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "9d63838a8401a4c09778168ff63c6f5daee280b73031cc14493a754946321899"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9d63838a8401a4c09778168ff63c6f5daee280b73031cc14493a754946321899"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9d63838a8401a4c09778168ff63c6f5daee280b73031cc14493a754946321899"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "bdeed42c8a66af34b127c3c0b7f049941ea47d23a7b9650de0a5f0d694ed1f42"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "bdeed42c8a66af34b127c3c0b7f049941ea47d23a7b9650de0a5f0d694ed1f42"
  end

  depends_on "pkgconf" => :test
  depends_on "re2c" => :test
  depends_on "php"

  allow_network_access! :test

  def install
    bin.install "pie.phar" => "pie"
    generate_completions_from_executable("php", bin/"pie", "completion")
  end

  test do
    system bin/"pie", "build", "apcu/apcu"
  end
end
