class Licensefinder < Formula
  desc "Find licenses for your project's dependencies"
  homepage "https://github.com/pivotal/LicenseFinder"
  url "https://github.com/pivotal/LicenseFinder.git",
      tag:      "v7.0.0",
      revision: "09d68fb7d87a1104d535df61a5f43f1038e70839"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ee30e3af8b607bf3459b92081bb20ac506e9c6cbc30e49bf665e7488c2db92fe"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ebd5182b0d43b904a165898445542742a9fb55995735ed8b82ad411bffe2f2df"
    sha256 cellar: :any_skip_relocation, monterey:       "1c746483fa01d193cff6d4eb439346dae7fe931abf2e222cf1869dc95e216a8c"
    sha256 cellar: :any_skip_relocation, big_sur:        "93935a784c0ad4cbb018c30d61a01cfae2ee9783ea7b7729ac08b416e3506419"
    sha256 cellar: :any_skip_relocation, catalina:       "93935a784c0ad4cbb018c30d61a01cfae2ee9783ea7b7729ac08b416e3506419"
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
