class Pie < Formula
  desc "PHP Installer for Extensions"
  homepage "https://github.com/php/pie"
  url "https://github.com/php/pie/releases/download/1.3.6/pie.phar"
  sha256 "5716cf5168c075355f2129257285d69d4a11eaf7f81723bcaf15be02e2b13b90"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "29bdd5ef36498ff50d3f0790d820a5b4f1f7180a2822f7a620a90fd0db953812"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "29bdd5ef36498ff50d3f0790d820a5b4f1f7180a2822f7a620a90fd0db953812"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "29bdd5ef36498ff50d3f0790d820a5b4f1f7180a2822f7a620a90fd0db953812"
    sha256 cellar: :any_skip_relocation, sonoma:        "a2faa28333c10de0993c8811accc3e89b18edfbc428ac1c2ff95a27a3f3e2038"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a2faa28333c10de0993c8811accc3e89b18edfbc428ac1c2ff95a27a3f3e2038"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a2faa28333c10de0993c8811accc3e89b18edfbc428ac1c2ff95a27a3f3e2038"
  end

  depends_on "php"

  def install
    bin.install "pie.phar" => "pie"
    generate_completions_from_executable("php", bin/"pie", "completion")
  end

  test do
    system bin/"pie", "build", "apcu/apcu"
  end
end
