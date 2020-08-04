class Fastlane < Formula
  desc "Easiest way to build and release mobile apps"
  homepage "https://fastlane.tools"
  url "https://github.com/fastlane/fastlane/archive/2.154.0.tar.gz"
  sha256 "6ca498892e233d47c052984e318135802869189f35ff63cced0ad0eb3b5ea304"
  license "MIT"
  head "https://github.com/fastlane/fastlane.git"

  bottle do
    cellar :any
    sha256 "78b926dc2bdd78fafb0853708361b8681efb63f22068d526405bc2e890ead79d" => :catalina
    sha256 "350f502006e05b47435fc9124b5573befc6d69274cdce9ed6bf73ea4bcd69a8f" => :mojave
    sha256 "94631d12a006fbc21942749e433b06e9a3fa7d8e36c20804213741fe0d153ef0" => :high_sierra
  end

  depends_on "ruby"

  def install
    ENV["GEM_HOME"] = libexec
    ENV["GEM_PATH"] = libexec

    system "gem", "build", "fastlane.gemspec"
    system "gem", "install", "fastlane-#{version}.gem", "--no-document"

    (bin/"fastlane").write <<~EOS
      #!/bin/bash
      export PATH="#{Formula["ruby"].opt_bin}:#{libexec}/bin:$PATH"
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
