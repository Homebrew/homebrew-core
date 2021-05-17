class Fastlane < Formula
  desc "Easiest way to build and release mobile apps"
  homepage "https://fastlane.tools"
  url "https://github.com/fastlane/fastlane/archive/2.183.1.tar.gz"
  sha256 "330aadd2fcfafa7fc6a56bf8fbf89db6e7160d6610dcf34fc0a464c1c64a28a4"
  license "MIT"
  head "https://github.com/fastlane/fastlane.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "6226d9ce40c1a9c038c83048b35285acc24f94fc49edceef1388127c35466621"
    sha256 cellar: :any, big_sur:       "6e7b51b5784690437e8943cf406e4830c83afdbe0399b6f30bb5ce0ee5a8ced8"
    sha256 cellar: :any, catalina:      "921b2fa2ce28c9726b8072c7fb644937fa053f4d877a9652910f9d602c084d30"
    sha256 cellar: :any, mojave:        "4388b00e98b3ac625f32d1f740768fbde710b1b622c878bbf539506b369c4b48"
  end

  depends_on "ruby@2.7"

  def install
    ENV["GEM_HOME"] = libexec
    ENV["GEM_PATH"] = libexec

    system "gem", "build", "fastlane.gemspec"
    system "gem", "install", "fastlane-#{version}.gem", "--no-document"

    (bin/"fastlane").write <<~EOS
      #!/bin/bash
      export PATH="#{Formula["ruby@2.7"].opt_bin}:#{libexec}/bin:$PATH"
      export FASTLANE_INSTALLED_VIA_HOMEBREW="true"
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
