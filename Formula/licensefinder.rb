class Licensefinder < Formula
  desc "Find licenses for your project's dependencies"
  homepage "https://github.com/pivotal/LicenseFinder"
  url "https://github.com/pivotal/LicenseFinder.git",
      tag:      "v6.14.1",
      revision: "ced7de9f22a627cb7bd2f11f18e41ffb914ec0b0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "171e1492cd68d3bd895a9e15357861438be00e738e9b75131765fbe8c0a95568"
    sha256 cellar: :any_skip_relocation, big_sur:       "9b1614bad0259f5924ae095dba5a0ef29dc7f7fdcf43e4aa832b4ee00c4ffe67"
    sha256 cellar: :any_skip_relocation, catalina:      "9b1614bad0259f5924ae095dba5a0ef29dc7f7fdcf43e4aa832b4ee00c4ffe67"
    sha256 cellar: :any_skip_relocation, mojave:        "217b3fca89c5ad77e84b0b20aca1daae8872b674d628c7c86d6f46b478c808c3"
  end

  depends_on "ruby@2.7" if MacOS.version <= :mojave

  def install
    ENV["GEM_HOME"] = libexec
    system "gem", "build", "license_finder.gemspec"
    system "gem", "install", "license_finder-#{version}.gem"
    bin.install libexec/"bin/license_finder"
    bin.env_script_all_files(libexec/"bin", GEM_HOME: ENV["GEM_HOME"])
  end

  test do
    gem_home = testpath/"gem_home"
    ENV["GEM_HOME"] = gem_home
    system "gem", "install", "bundler"

    mkdir "test"
    (testpath/"test/Gemfile").write <<~EOS
      source 'https://rubygems.org'
      gem 'license_finder', '#{version}'
    EOS
    cd "test" do
      ENV.prepend_path "PATH", gem_home/"bin"
      system "bundle", "install"
      ENV.prepend_path "GEM_PATH", gem_home
      assert_match "license_finder, #{version}, MIT",
                   shell_output(bin/"license_finder", 1)
    end
  end
end
