class Facad < Formula
  desc "Modern, colorful directory listing tool for the command-line"
  homepage "https://github.com/yellow-footed-honeyguide/facad"
  url "https://github.com/yellow-footed-honeyguide/facad/archive/refs/tags/v2.11.0.tar.gz"
  sha256 "40e63c5ef7c28f35f40baa529dc329cbb34384f0c080bad5af916652df7a2a93"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d95bc56d073923a8668a6eeddc66eb41ff6da7e7f57cecfdfe5af31d53860bcd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2f6fda7fb685491123a0d1f408af1830de40c8f51a89abcfd040d7bf78c9e9e2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4b42f699b1a574333408a8767bd9d4cae43e15ff0a2a06b9e4d4a01151ade679"
    sha256 cellar: :any_skip_relocation, sonoma:        "37026e87eeaa5e480e5f9d3428d03c97a993811107513f8bcd42f58461e0a62d"
    sha256 cellar: :any_skip_relocation, ventura:       "85be8a6aa5784257391fd25dffa9f1aa32fe43918700e805dceaebda56e22f8a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a2920a54f705a96d949af168ce7a67f2a5e3bcc4291e9d673ac3dc76a1267255"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build

  def install
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    assert_match "facad version #{version}", shell_output("#{bin}/facad --version")

    Dir.mkdir("foobar")
    assert_match "📁 foobar", shell_output(bin/"facad")
  end
end
