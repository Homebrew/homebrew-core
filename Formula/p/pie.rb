class Pie < Formula
  desc "PHP Installer for Extensions"
  homepage "https://github.com/php/pie"
  url "https://github.com/php/pie/releases/download/1.6.1/pie.phar"
  sha256 "e99400532e25cd3b65cb7b6688df93c9296a689f01bb0a4471869a3cbbac83ba"
  license "BSD-3-Clause"

  bottle do
    manifest_sha256 "d50cab100ff55c3baa82ed2d8f5ad0e1e6f9a0c235bdcb6169db1ff639ed4b84"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "9b4c665f38896ad16d875861302e5753b1b7419ebf840a8d4319c1a852fdd48a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9b4c665f38896ad16d875861302e5753b1b7419ebf840a8d4319c1a852fdd48a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9b4c665f38896ad16d875861302e5753b1b7419ebf840a8d4319c1a852fdd48a"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "1314c68f3c5115784ba2d8feddf52b292bd2c3d937a90ec46a4c5be3ac40aa3e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "1314c68f3c5115784ba2d8feddf52b292bd2c3d937a90ec46a4c5be3ac40aa3e"
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
