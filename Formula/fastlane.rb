class Fastlane < Formula
  desc "Easiest way to build and release mobile apps"
  homepage "https://fastlane.tools"
  url "https://github.com/fastlane/fastlane/archive/2.180.0.tar.gz"
  sha256 "f91c275bce16f9b0e5c2720ec278abdffec405ad983ec75269d12832f589178c"
  license "MIT"
  head "https://github.com/fastlane/fastlane.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "8967e466b9855e47a54b7a9b6f575657c18383e1c0a85fd0f873f20bbd8751ad"
    sha256 cellar: :any, big_sur:       "a317526bd38055c04301187f14d34df96ec5a06db1a88bc5178f3c9a651e5b8d"
    sha256 cellar: :any, catalina:      "6e2e9e9b713965ab7b2f2598cc0174ded09840b7a9b6668d08dc05584a9d9a5c"
    sha256 cellar: :any, mojave:        "1e5ea8ea6e5235a95034f5f7fcfbfb9833d76e6c681c6bb32975d1b69cd53400"
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
