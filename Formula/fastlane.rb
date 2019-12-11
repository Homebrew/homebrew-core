class Fastlane < Formula
  desc "Easiest way to build and release mobile apps"
  homepage "https://fastlane.tools"
  url "https://github.com/fastlane/fastlane/archive/2.137.0.tar.gz"
  sha256 "ff3813d75bbced1030b5d7e3e714e75f358788f74d951be796515e8ec4e7ec79"
  head "https://github.com/fastlane/fastlane.git"

  RUBY_DEP = "ruby@2.5".freeze

  depends_on RUBY_DEP

  def install
    # Build and unpack gem into lib directory to reference from our Gemfile
    system "gem", "build", "fastlane.gemspec"
    gem_name = Dir["fastlane-*.gem"].last
    version_name = File.basename(gem_name, ".gem")
    system "gem", "unpack", gem_name, "--target", lib

    # Need to also unpack the gemspec to install from bundler
    # Manually copying since 'gem unpack' doesn't recognize '--target'
    system "gem", "unpack", gem_name, "--spec"
    cp "#{version_name}.gemspec", "#{lib}/#{version_name}/fastlane.gemspec"

    # Gemfile referencing our unpacked gem
    (prefix/libexec/"Gemfile").write <<~EOS
      source "https://rubygems.org"
      gem "fastlane", path: "#{lib}/#{version_name}"
    EOS

    ENV["GEM_HOME"] = libexec
    ENV["BUNDLE_PATH"] = libexec
    ENV["BUNDLE_GEMFILE"] = libexec/"Gemfile"
    ENV.prepend_path "PATH", Formula[RUBY_DEP].opt_bin

    # Installing bundler and fastlane dependencies
    system "gem", "install", "bundler"
    bundle = Dir["#{libexec}/**/bundle"].last
    system bundle, "install", "--without", "test"

    # fastlane executable referencing our gems installed in libexec
    (bin/"fastlane").write <<~EOS
      #!/bin/bash
      export PATH="#{Formula[RUBY_DEP].opt_bin}:$PATH}"
      GEM_HOME="#{libexec}" GEM_PATH="#{libexec}" BUNDLE_GEMFILE="#{libexec}/Gemfile" \\
        exec "#{bundle}" exec "#{libexec}/bin/fastlane" "$@"
    EOS
    chmod("+x", File.join(bin, "fastlane"))
  end

  test do
    output = shell_output("#{bin}/fastlane --version")
    assert_true output.include?("fastlane #{version}")
    assert_true output.include?("#{prefix}/lib/fastlane-#{versionb}/bin/fastlane")
  end
end
