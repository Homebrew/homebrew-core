class Pie < Formula
  desc "PHP Installer for Extensions"
  homepage "https://github.com/php/pie"
  url "https://github.com/php/pie/releases/download/1.4.0/pie.phar"
  sha256 "b4a50f2c1c22eb72321ee462039b71f180c2c86778d8fa2a7c18812766468c3d"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d5c7ad29830c0cbcb428ae040e91a918f499da598d458c4e738d2a0664f79ab0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d5c7ad29830c0cbcb428ae040e91a918f499da598d458c4e738d2a0664f79ab0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d5c7ad29830c0cbcb428ae040e91a918f499da598d458c4e738d2a0664f79ab0"
    sha256 cellar: :any_skip_relocation, sonoma:        "7ad0ac42e4e74deed06d985e9e3eb22f3ecd138a0d330213778ea934a7cf0181"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7ad0ac42e4e74deed06d985e9e3eb22f3ecd138a0d330213778ea934a7cf0181"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7ad0ac42e4e74deed06d985e9e3eb22f3ecd138a0d330213778ea934a7cf0181"
  end

  depends_on "pkgconf" => :test
  depends_on "re2c" => :test
  depends_on "php"

  def install
    bin.install "pie.phar" => "pie"
    generate_completions_from_executable("php", bin/"pie", "completion")
  end

  test do
    system bin/"pie", "build", "apcu/apcu"
  end
end
