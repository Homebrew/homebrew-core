class Deadfinder < Formula
  desc "Finds broken links"
  homepage "https://rubygems.org/gems/deadfinder"
  url "https://github.com/hahwul/deadfinder/archive/refs/tags/1.8.0.tar.gz"
  sha256 "508d901cc3556918a97cc65ff0c19e17641cfa3f60272d362d6e2a2948c442f1"
  license "MIT"
  head "https://github.com/hahwul/deadfinder.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "366fd0b10a75208c25f1445871d3d655cb3ac96b12ec5fd52316007b0ed622ff"
    sha256 cellar: :any,                 arm64_sequoia: "8c7455576e55db66e9206442359dd3ad284b6888cb3f8ae8553a9ffa580f937c"
    sha256 cellar: :any,                 arm64_sonoma:  "6ccd4d5afc1cd29bec2d1d74884ae9160f4c1f39c04f57d4a3737a2e8be92597"
    sha256 cellar: :any,                 arm64_ventura: "ca02114cfe941470db280c7214ed84ae06d99b4ead8c9c8c94a6040cea68e7ec"
    sha256 cellar: :any,                 sonoma:        "b66336c44e9981a1c1fbb9c4e647bc2698b8b9332339b4b097a93dcb420e63df"
    sha256 cellar: :any,                 ventura:       "09ed31aec484ff2db527b31e2f6b6ccb7a256a4d1f935fd97157ca1990e742ab"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1f61606448e1c1a65bd733f64f2d787db3ce116516d03352a8c053adae0d960c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "46bcf0c046527a94139bc879be13682b910dbbc36a391208ab9b8cb987dc9eb4"
  end

  depends_on "pkgconf" => :build
  depends_on "ruby"

  uses_from_macos "libffi"
  uses_from_macos "libxml2"
  uses_from_macos "libxslt"
  uses_from_macos "xz"
  uses_from_macos "zlib"

  def install
    ENV["GEM_HOME"] = libexec
    ENV["NOKOGIRI_USE_SYSTEM_LIBRARIES"] = "1"

    system "bundle", "config", "set", "without", "development", "test"
    system "bundle", "install"
    system "gem", "build", "#{name}.gemspec"
    system "gem", "install", "#{name}-#{version}.gem"

    bin.install libexec/"bin/#{name}"
    bin.env_script_all_files(libexec/"bin", GEM_HOME: ENV["GEM_HOME"])

    # Remove mkmf.log files to avoid shims references
    rm Dir["#{libexec}/extensions/*/*/*/mkmf.log"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/deadfinder version")

    assert_match "Task completed", shell_output("#{bin}/deadfinder url https://brew.sh")
  end
end
