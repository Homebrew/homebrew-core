class Licensefinder < Formula
  desc "Find licenses for your project's dependencies"
  homepage "https://github.com/pivotal/LicenseFinder"
  url "https://github.com/pivotal/LicenseFinder.git",
      tag:      "v7.0.0",
      revision: "09d68fb7d87a1104d535df61a5f43f1038e70839"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b32049d8e378cc39897671e8f4c714fd313f22fee282005d4fcaaf75e4866fe2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7d12c6eda18a5a481a599a1daca71b416f9793f5a1dab1f1f08ca9cccb66df90"
    sha256 cellar: :any_skip_relocation, monterey:       "fe9ba07d6be035ff797f4d0730f437f28a53e173b8d84577dd712aa2646fdc1f"
    sha256 cellar: :any_skip_relocation, big_sur:        "f227f4f12d350dfc41eb8c42450a45ded144c2f275211113c7ae1ddaede242b9"
    sha256 cellar: :any_skip_relocation, catalina:       "f227f4f12d350dfc41eb8c42450a45ded144c2f275211113c7ae1ddaede242b9"
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
