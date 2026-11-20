class Pie < Formula
  desc "PHP Installer for Extensions"
  homepage "https://github.com/php/pie"
  url "https://github.com/php/pie/releases/download/1.5.5/pie.phar"
  sha256 "2ca0dff6868f1b53c095625674deef38ac698588e0a25e4321cd834a5b7553bc"
  license "BSD-3-Clause"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "6617801cfba6dc3e3870c6a96e58a052f4efce2916242487999d499824293e41"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "6617801cfba6dc3e3870c6a96e58a052f4efce2916242487999d499824293e41"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6617801cfba6dc3e3870c6a96e58a052f4efce2916242487999d499824293e41"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "6d5b2b744543caecdae374996514bea22f984496b6cc12c64c415da0a2e231bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "6d5b2b744543caecdae374996514bea22f984496b6cc12c64c415da0a2e231bb"
  end

  depends_on "pkgconf" => :test
  depends_on "re2c" => :test
  depends_on "php@8.5"

  allow_network_access! :test

  def install
    # TODO: Switch to following when using unversioned `php`:
    # bin.install "pie.phar" => "pie"
    libexec.install "pie.phar" => "pie"
    (bin/"pie").write <<~PHP
      #!#{formula_opt_bin("php@8.5")}/php
      <?php require '#{libexec}/pie';
    PHP
    chmod "+x", bin/"pie"
    generate_completions_from_executable(bin/"pie", "completion")
  end

  test do
    system bin/"pie", "build", "apcu/apcu"
  end
end
