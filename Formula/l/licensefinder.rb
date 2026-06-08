class Licensefinder < Formula
  desc "Find licenses for your project's dependencies"
  homepage "https://github.com/pivotal/LicenseFinder"
  # pull from git tag as gemspec uses `git ls-files`
  # For versions following v7.1.0, may be able to remove 4cac18e5 patch.
  url "https://github.com/pivotal/LicenseFinder.git",
      tag:      "v7.2.1",
      revision: "00b04cb91e8ec9021c939ccfceb69d4047f4c8ca"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bc612bca33980e0d1b2c51b001fc295934c7d23bec6ecd3e546294488bf384eb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bc612bca33980e0d1b2c51b001fc295934c7d23bec6ecd3e546294488bf384eb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bc612bca33980e0d1b2c51b001fc295934c7d23bec6ecd3e546294488bf384eb"
    sha256 cellar: :any_skip_relocation, sonoma:        "bc612bca33980e0d1b2c51b001fc295934c7d23bec6ecd3e546294488bf384eb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d19855c60c9c10d7332caa54afd4af6edf8d2238ca52ff7501b3dc0a9753c43e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d19855c60c9c10d7332caa54afd4af6edf8d2238ca52ff7501b3dc0a9753c43e"
  end

  depends_on "ruby"

  # Ruby 3.3 introduced changes that mean we now need to manually require
  # racc. See https://bugs.ruby-lang.org/issues/19702 for details.
  # LicenseFinder versions after v7.1.0 may address this requirement.
  patch do
    url "https://github.com/pivotal/LicenseFinder/commit/4cac18e5c7a48f72700b8de4db97d3150637a20d.patch?full_index=1"
    sha256 "7a7a9b201cd34a5f868901841ba5f144f0e75580664c8ec024792449348f5875"
  end

  # The logger gem was removed from the stdlib in Ruby 4.0.0.
  # Project has had no commits since May 2024, so we patch the gemspec to add it as a dependency.
  patch :DATA

  def install
    ENV["GEM_HOME"] = libexec
    system "gem", "build", "license_finder.gemspec"
    system "gem", "install", "license_finder-#{version}.gem"
    bin.install libexec/"bin/license_finder"
    bin.env_script_all_files(libexec/"bin", GEM_HOME: ENV["GEM_HOME"])
  end

  test do
    ENV["GEM_PATH"] = ENV["GEM_HOME"] = testpath
    ENV.prepend_path "PATH", Formula["ruby"].opt_bin

    (testpath/"Gemfile").write <<~EOS
      source 'https://rubygems.org'
      gem 'license_finder', '#{version}'
      gem 'racc'
    EOS

    system "bundle", "install"
    assert_match "license_finder, #{version}, #{license}",
                  shell_output(bin/"license_finder", 1)
  end
end
__END__
diff --git a/license_finder.gemspec b/license_finder.gemspec
index 419a3a6d..62e40adc 100644
--- a/license_finder.gemspec
+++ b/license_finder.gemspec
@@ -45,6 +45,7 @@ Gem::Specification.new do |s|

   s.add_dependency 'bundler'
   s.add_dependency 'csv', '~> 3.2'
+  s.add_dependency 'logger', '~> 1.6.4'
   s.add_dependency 'rubyzip', '>=1', '<3'
   s.add_dependency 'thor', '~> 1.2'
   s.add_dependency 'tomlrb', '>= 1.3', '< 2.1'
