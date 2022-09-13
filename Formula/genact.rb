class Genact < Formula
  desc "Nonsense activity generator"
  homepage "https://github.com/svenstaro/genact"
  url "https://github.com/svenstaro/genact/archive/v1.1.1.tar.gz"
  sha256 "231ea3735c59a659264d11b7ef1a6a2572c73f7bd7c9cb3efb940709673b58bf"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8bb98caea9d48daf6bf7282196f8ef5d26b9af6cc938846231acf84f6daf2b10"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "abf41f61085473110768c6bf3949da92eb95f960db9853ab9077655366fbe6d4"
    sha256 cellar: :any_skip_relocation, monterey:       "848b4c4bbf990af8798799468ad97cba5bdf97cca3906f93be918f908711e5bc"
    sha256 cellar: :any_skip_relocation, big_sur:        "1c77a2569913133423809329809203eef33b2a9f127814fb8db6fd0550ecd320"
    sha256 cellar: :any_skip_relocation, catalina:       "3c3e61d6caf2a15307ebc795e8011227dab39db046424d5e8956fd54005bd919"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d6b47891d0d8017240284ca431100a057160dcc1236c57c0d94d7b72bc2daa7f"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "Available modules:", shell_output("#{bin}/genact --list-modules")
  end
end
