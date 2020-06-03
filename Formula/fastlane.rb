class Fastlane < Formula
  desc "Easiest way to build and release mobile apps"
  homepage "https://fastlane.tools"
  url "https://github.com/fastlane/fastlane/archive/2.149.0.tar.gz"
  sha256 "3713d7c30af788dd4fd3788e344b06701678c076edc7b89f3c899c2465ce07e1"
  head "https://github.com/fastlane/fastlane.git"

  bottle do
    cellar :any
    sha256 "007007048a0dabfb33a5541a4547e0c8f4226b15e4878a9b7a844816286b94bb" => :catalina
    sha256 "759e366743e9a35ea8d8e65c522a439c33f298efaa3cdd5cd99f4d227a5d4bdc" => :mojave
    sha256 "20ae85f8a99e4103ac0599b089dc7a08280ee3feae422e14579ee642f055c310" => :high_sierra
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
