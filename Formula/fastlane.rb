class Fastlane < Formula
  desc "Easiest way to build and release mobile apps"
  homepage "https://fastlane.tools"
  url "https://github.com/fastlane/fastlane/archive/2.146.1.tar.gz"
  sha256 "6ab82156e95ec5f548c8af8e91b47747e815129b50a1da8db6e7f05c1d6f00c7"
  head "https://github.com/fastlane/fastlane.git"

  bottle do
    cellar :any
    sha256 "9eac24b6639f51fa19a3226404a239de984f9517a5a5ecc1159107a70b658154" => :catalina
    sha256 "95170a0457029c960844750a222878d56191da3e18f0744debbcf636b764e910" => :mojave
    sha256 "e14d2883a8a3385b28e9b6f5d88c5762aa9ddd19ffe3239b11455a9fcf600eb8" => :high_sierra
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
