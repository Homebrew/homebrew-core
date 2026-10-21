class Pie < Formula
  desc "PHP Installer for Extensions"
  homepage "https://github.com/php/pie"
  url "https://github.com/php/pie/releases/download/1.5.2/pie.phar"
  sha256 "fe70c59738cf56ec00a818cf9cb9593da171aac86f5f1f859995b8839dfd2cc7"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "da229a2d2e052c44ea0553ff3caee2139f8c3bb87d13614552ec5bfed23f7ce9"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "da229a2d2e052c44ea0553ff3caee2139f8c3bb87d13614552ec5bfed23f7ce9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "da229a2d2e052c44ea0553ff3caee2139f8c3bb87d13614552ec5bfed23f7ce9"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "a7da58030199c4f1e6a67d729af1b91d01f55fe0e54e29ba816a148201fad533"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "a7da58030199c4f1e6a67d729af1b91d01f55fe0e54e29ba816a148201fad533"
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
