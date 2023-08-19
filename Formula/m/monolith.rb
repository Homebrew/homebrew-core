class Monolith < Formula
  desc "CLI tool for saving complete web pages as a single HTML file"
  homepage "https://github.com/Y2Z/monolith"
  url "https://github.com/Y2Z/monolith/archive/v2.7.0.tar.gz"
  sha256 "2076b479638d4ae5c1d1009c915527213175e6ae1b18f95d296092cbda0e7cc2"
  license "CC0-1.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7906a2428d7e39f543cbf7fdecb72ba83e7853400307f8c3e8acad7e7fe4c800"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e8fa307ca859044ac1c9699a35dfd72c8746bbb4a96909ea6b9f65a025483694"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "90a44adc8f1ccbb88da3c6c904472c4944b6146ffacb39ba380d99f731391c0a"
    sha256 cellar: :any_skip_relocation, ventura:        "7d13cc03f1f56004b2d28eb7e0dd7849544bcd60b035f8a44358a087295aa8db"
    sha256 cellar: :any_skip_relocation, monterey:       "0f4d4ecdf066f62844db3422e1ba1219ca9ca187879cf38d95f860efda7f3dde"
    sha256 cellar: :any_skip_relocation, big_sur:        "53dde0061e4b7c58d7400aae84e4164a02ac003f2edb7c69c0b4226077d8c0f6"
    sha256 cellar: :any_skip_relocation, catalina:       "d695f22c79b7b3c1ca434db9c8dfc87acd97c69d9ecf9463530dc15a8e0c58bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f58a88c34fe41097ce534b2c0aef72d5f8805bfc349857b29b9e244a209e22ef"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"monolith", "https://lyrics.github.io/db/P/Portishead/Dummy/Roads/"
  end
end
