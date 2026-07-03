class Licensee < Formula
  desc "Detect under what license a project is distributed"
  homepage "https://licensee.github.io/licensee/"
  url "https://github.com/licensee/licensee.git",
      tag:      "v10.0.0",
      revision: "cffd1eb1e3b52d85c4fe17f82e04cc1731cf15c4"
  license "MIT"
  head "https://github.com/licensee/licensee.git", branch: "main"

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "libgit2"
  depends_on "ruby"

  uses_from_macos "libxml2"
  uses_from_macos "libxslt"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  # TODO: Remove resource when there is a new release
  resource "rugged" do
    url "https://github.com/libgit2/rugged.git",
        tag:      "v1.9.0",
        revision: "5b28daf1fca547f875489650345bf9067e78fa25"

    # Backport fix to use brew libgit2
    patch do
      url "https://github.com/libgit2/rugged/commit/5fee507fef1a322efabceee6f938195795d90eea.patch?full_index=1"
      sha256 "4495f461391564df09ece50e7eb16bc8242af11c7a732180f9ce76e8b824e660"
    end
  end

  def install
    ENV["BUNDLE_FORCE_RUBY_PLATFORM"] = "1"
    ENV["BUNDLE_VERSION"] = "system" # Avoid installing Bundler into the keg
    ENV["BUNDLE_WITHOUT"] = "development test"
    ENV["GEM_HOME"] = libexec

    resource("rugged").stage do |r|
      system "gem", "build", "rugged.gemspec"
      system "gem", "install", "--ignore-dependencies", "rugged-#{r.version}.gem", "--", "--use-system-libraries"
    end

    system "bundle", "config", "set", "build.nokogiri", "--use-system-libraries"
    system "bundle", "config", "set", "build.rugged", "--use-system-libraries"
    system "bundle", "install"
    system "gem", "build", "#{name}.gemspec"
    system "gem", "install", "#{name}-#{version}.gem"

    bin.install libexec/"bin/#{name}"
    bin.env_script_all_files(libexec/"bin", GEM_HOME: ENV["GEM_HOME"])
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/licensee version").strip

    assert_match "BSD-2-Clause", shell_output("#{bin}/licensee detect https://github.com/Homebrew/brew.git")
    assert_match "Exact match!", shell_output("#{bin}/licensee diff --license BSD-2-Clause https://github.com/Homebrew/brew.git")
  end
end
