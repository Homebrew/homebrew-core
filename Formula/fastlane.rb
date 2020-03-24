class Fastlane < Formula
  desc "Easiest way to build and release mobile apps"
  homepage "https://fastlane.tools"
  url "https://github.com/fastlane/fastlane/archive/2.144.0.tar.gz"
  sha256 "4fefb6b4763369284bf5bad93d0d9fced211614b46ea11ed9b30e852a7f5bc23"
  head "https://github.com/fastlane/fastlane.git"

  bottle do
    cellar :any
    sha256 "0cb2ce0e6111a91035c84ee59bdae3050ae16ecb3975ca5aec8956b73b8d7640" => :catalina
    sha256 "f8b35f5f4a824ee7c4ba101912a339479638020aa9abac20a58a27fc08e240e0" => :mojave
    sha256 "48de0549fb9001ff5305f9dd7f5f5a8daf7bcd4cfca00f889afa41f4db626fdc" => :high_sierra
  end

  depends_on "ruby@2.5"

  def install
    ENV["GEM_HOME"] = libexec
    ENV["GEM_PATH"] = libexec

    system "gem", "build", "fastlane.gemspec"
    system "gem", "install", "fastlane-#{version}.gem", "--no-document"

    (bin/"fastlane").write <<~EOS
      #!/bin/bash
      export PATH="#{Formula["ruby@2.5"].opt_bin}:#{libexec}/bin:$PATH"
      GEM_HOME="#{libexec}" GEM_PATH="#{libexec}" \\
        exec "#{libexec}/bin/fastlane" "$@"
    EOS
    chmod "+x", bin/"fastlane"
  end

  test do
    assert_match "fastlane #{version}", shell_output("#{bin}/fastlane --version")

    actions_output = shell_output("#{bin}/fastlane actions")
    assert_match "gym", actions_output
    assert_match "pilot", actions_output
    assert_match "screengrab", actions_output
    assert_match "supply", actions_output
  end
end
