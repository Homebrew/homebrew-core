class Autocorrect < Formula
  desc "Linter and formatter to improve copywriting, correct spaces, words between CJK"
  homepage "https://huacnlee.github.io/autocorrect/"
  url "https://github.com/huacnlee/autocorrect/archive/refs/tags/v2.10.0.tar.gz"
  sha256 "d6800d783edbab75769da72ca06b89375c371855c7b1990651c1bf58ff66a5f0"
  license "MIT"
  head "https://github.com/huacnlee/autocorrect.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5933231343fe64a62f88c7e1d89a0fb7116fcdfd3f44bfd514035ae60b9f4c06"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6168fcbcdba8f8f1b8e02e944145020064bf66728cbf864e42deee7aba70f753"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9ed634f594f53297621c7f576872aaf86ecaeff3e52adb7c2d7e91d9c29defaf"
    sha256 cellar: :any_skip_relocation, sonoma:         "35f4665e55591810bb0dfdbe1ba63608f6fba22e85f1190071b944f122540d4d"
    sha256 cellar: :any_skip_relocation, ventura:        "79c2db3ae2178a7a40d7152ab1623ba631c30ad11277dbef7c98e4d51c68bcd3"
    sha256 cellar: :any_skip_relocation, monterey:       "a3a84ea0712785d9a7def803b4e0bfa6eae7b5ad583441250cca8e2c624be63b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4bbed50bb5675f55941a512a936177b8cbe87b2f94910d319158d5556b9d5c2b"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "autocorrect-cli")
  end

  test do
    (testpath/"autocorrect.md").write "Hello世界"
    out = shell_output("#{bin}/autocorrect autocorrect.md").chomp
    assert_equal "Hello 世界", out
  end
end
