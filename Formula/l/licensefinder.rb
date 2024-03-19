class Licensefinder < Formula
  desc "Find licenses for your project's dependencies"
  homepage "https://github.com/pivotal/LicenseFinder"
  # pull from git tag as gemspec uses `git ls-files`
  # For versions following v7.1.0, may be able to remove 4cac18e5 patch.
  url "https://github.com/pivotal/LicenseFinder.git",
      tag:      "v7.1.0",
      revision: "81092404aeaf1cb39dbf2551f50f007ed049c26c"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2dd84e133cb82c6ed665cc0eaf65255c2c9dabd20c87a4c8d3163c758c3363c7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2dd84e133cb82c6ed665cc0eaf65255c2c9dabd20c87a4c8d3163c758c3363c7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2dd84e133cb82c6ed665cc0eaf65255c2c9dabd20c87a4c8d3163c758c3363c7"
    sha256 cellar: :any_skip_relocation, sonoma:         "b3ee729550f311358fbd9eda1f7608db191e2b29548637f6b951d75b84c9230b"
    sha256 cellar: :any_skip_relocation, ventura:        "b3ee729550f311358fbd9eda1f7608db191e2b29548637f6b951d75b84c9230b"
    sha256 cellar: :any_skip_relocation, monterey:       "b3ee729550f311358fbd9eda1f7608db191e2b29548637f6b951d75b84c9230b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a202d220452af880ab1a2cb0c756d44cca45eef6f71953b243baadc78b777191"
  end

  depends_on "ruby"

  # Ruby 3.3 introduced changes that mean we now need to manually require
  # racc. See https://bugs.ruby-lang.org/issues/19702 for details.
  # LicenseFinder versions after v7.1.0 may address this requirement.
  patch do
    url "https://github.com/pivotal/LicenseFinder/commit/4cac18e5c7a48f72700b8de4db97d3150637a20d.patch?full_index=1"
    sha256 "7a7a9b201cd34a5f868901841ba5f144f0e75580664c8ec024792449348f5875"
  end

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
