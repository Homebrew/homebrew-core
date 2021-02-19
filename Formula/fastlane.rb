class Fastlane < Formula
  desc "Easiest way to build and release mobile apps"
  homepage "https://fastlane.tools"
  url "https://github.com/fastlane/fastlane/archive/2.175.0.tar.gz"
  sha256 "72ca303e7423caaa99df3aecfb841b9f15a74af8547f2aad9c047870458aa590"
  license "MIT"
  head "https://github.com/fastlane/fastlane.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "f426b0fb779e80de18de67b52f9552ee666ae8b9d1eac2c0631be59a33429b1b"
    sha256 cellar: :any, big_sur:       "4eac8c1706c541acbfa838b6aea84cf39b74c242e2aadefd0a09ac185a2f24c9"
    sha256 cellar: :any, catalina:      "35c4d2b53eda31363256febf927c9b7a305ec7c27173651cc87adf0b4dc5316e"
    sha256 cellar: :any, mojave:        "6047bf36c5cd07630d35ee2e12b79782f12550a1b5acdd22badf7c4fcc826cf4"
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
