class Pie < Formula
  desc "PHP Installer for Extensions"
  homepage "https://github.com/php/pie"
  url "https://github.com/php/pie/releases/download/1.6.0/pie.phar"
  sha256 "81041b276f4e23dfdfa6dc941e5745f9adec824a1bcf6141e226181ef43f519e"
  license "BSD-3-Clause"

  bottle do
    manifest_sha256 "ecee352ca1107ded96a630963c5c86ada75a2834ba1e835085c290672ec6b7c5"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "77084e96c5f4569dda30f0c4fbb5420da171b5050f0c095e4df74b9882fc4dae"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "77084e96c5f4569dda30f0c4fbb5420da171b5050f0c095e4df74b9882fc4dae"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "77084e96c5f4569dda30f0c4fbb5420da171b5050f0c095e4df74b9882fc4dae"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "c42a7e1ff9f71a974fe52928bb8b1dad11c898f748a3d95cd125f8f1a0874c00"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "c42a7e1ff9f71a974fe52928bb8b1dad11c898f748a3d95cd125f8f1a0874c00"
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
