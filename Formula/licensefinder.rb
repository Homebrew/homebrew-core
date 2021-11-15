class Licensefinder < Formula
  desc "Find licenses for your project's dependencies"
  homepage "https://github.com/pivotal/LicenseFinder"
  url "https://github.com/pivotal/LicenseFinder.git",
      tag:      "v6.14.2",
      revision: "408a49a0bad4685a942571616a0302a4cca252f3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2abb62a07bd2fd7a110b8fca54dc181bfc6a1c470117f1c9c0d4188f73dee4e6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2c77602c72a735f68f17f4040c06bc213a35069626fe6c2b75cc11e50d3e8d3b"
    sha256 cellar: :any_skip_relocation, monterey:       "55aed6566f8b9ea58509de32306aa1bae1179fcb3e27caeccdb426f3ac607a53"
    sha256 cellar: :any_skip_relocation, big_sur:        "dfc34cd13fef698381ca1a004cf474de10f2c284b239af5373da3e2c881b7bc9"
    sha256 cellar: :any_skip_relocation, catalina:       "dfc34cd13fef698381ca1a004cf474de10f2c284b239af5373da3e2c881b7bc9"
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
