class Deadfinder < Formula
  desc "Finds broken links"
  homepage "https://rubygems.org/gems/deadfinder"
  url "https://github.com/hahwul/deadfinder/archive/refs/tags/1.5.0.tar.gz"
  sha256 "5575127e8ca9c8531991ad32d04bda3f55f13cc657cf01ac0c6ace9d01c59a8a"
  license "MIT"
  head "https://github.com/hahwul/deadfinder.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "15cc6a6fd22f9496fc574dd5ec2f11b66cdfe22e3e79627b8f0342af963785d5"
    sha256 cellar: :any,                 arm64_sonoma:  "4d5f38a1d1111d0748c2707257da54f2da72e552ca4c58e0f46a9162c934f632"
    sha256 cellar: :any,                 arm64_ventura: "633a52fb28417d9d004fa0f935c6a513895efd1a64aa49c1a59b335ef3a5e4bb"
    sha256 cellar: :any,                 sonoma:        "596a5646e4ef21b9d604ab2e80e1c8a03c4f0a87ef091ebc53f12bd9152d19db"
    sha256 cellar: :any,                 ventura:       "ebe96e926c4471c1fac95d1f8144d65660605c5e18a58efe60a0054e6b68eb0e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6a3087b8f8b3855dbf5d3b2231e5642cdcdc191ec45adbed958a62de4f7ed355"
  end

  depends_on "ruby"

  uses_from_macos "libffi"
  uses_from_macos "libxml2"
  uses_from_macos "libxslt"
  uses_from_macos "xz"
  uses_from_macos "zlib"

  on_linux do
    depends_on "pkg-config" => :build
  end

  def install
    ENV["GEM_HOME"] = libexec
    ENV["NOKOGIRI_USE_SYSTEM_LIBRARIES"] = "1"
    system "bundle", "config", "set", "without", "development", "test"
    system "bundle", "install"
    system "gem", "build", "deadfinder.gemspec"
    system "gem", "install", "deadfinder-#{version}.gem"
    bin.install libexec/"bin/deadfinder"
    bin.env_script_all_files(libexec/"bin", GEM_HOME: ENV["GEM_HOME"])
  end

  test do
    assert_match version.to_s, shell_output(bin/"deadfinder version")

    assert_match "Done", shell_output(bin/"deadfinder url https://brew.sh")
  end
end
