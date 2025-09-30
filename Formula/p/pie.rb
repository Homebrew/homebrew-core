class Pie < Formula
  desc "PHP Installer for Extensions"
  homepage "https://github.com/php/pie"
  url "https://github.com/php/pie/releases/download/1.2.1/pie.phar"
  sha256 "b3a30c3e70f6b590505f76e27f1163b328b3523f369200a8f769ca1005ac42f7"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f92f04f969d77f970faa6c6463a70dbb758778d159feaa3b9606d1a17a9026ca"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f92f04f969d77f970faa6c6463a70dbb758778d159feaa3b9606d1a17a9026ca"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f92f04f969d77f970faa6c6463a70dbb758778d159feaa3b9606d1a17a9026ca"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f92f04f969d77f970faa6c6463a70dbb758778d159feaa3b9606d1a17a9026ca"
    sha256 cellar: :any_skip_relocation, sonoma:        "e0952c74ab24eb0054f500fb169c1acf61d17ec87dec3ee6e9ce00a2f4ab5224"
    sha256 cellar: :any_skip_relocation, ventura:       "e0952c74ab24eb0054f500fb169c1acf61d17ec87dec3ee6e9ce00a2f4ab5224"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e0952c74ab24eb0054f500fb169c1acf61d17ec87dec3ee6e9ce00a2f4ab5224"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e0952c74ab24eb0054f500fb169c1acf61d17ec87dec3ee6e9ce00a2f4ab5224"
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
