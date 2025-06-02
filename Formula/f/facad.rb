class Facad < Formula
  desc "Modern, colorful directory listing tool for the command-line"
  homepage "https://github.com/yellow-footed-honeyguide/facad"
  url "https://github.com/yellow-footed-honeyguide/facad/archive/refs/tags/v2.20.13.tar.gz"
  sha256 "381231de5429cc47fccdd163a34691b4478a33deea7146c78676d559d284439e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "531b9fc1493250c2f12e7528cf444bf3e7751d27245337e3ffeddf1afa4c8b92"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "51ae9755ae9ee5957dcdaa2da6a07f8224fbab9b4311d13ddd3d979bf571ae9e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f3b6c413bedc1b61a406fdc0c3efe28c29d91fdbcf320639dae4454d512be8e2"
    sha256 cellar: :any_skip_relocation, sonoma:        "35b192bfefc8f26e4c7763085c090380e561e9124b5d1e5a4a31966554828c5a"
    sha256 cellar: :any_skip_relocation, ventura:       "c2bc9275cf97c25ad138cd1d45ef09ffa22dd7965fbb68557ae30885368b7d00"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1f621e7fd54c732d10a5d27d3c8a20f719b8710ccd8a5f5360c6ef45acf427aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a37aec3747556f81333a13b7d860c22cfd31e8b05193b2414630dc8d0925649a"
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
