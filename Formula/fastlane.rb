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
    sha256 cellar: :any, arm64_big_sur: "b251ce1d12dce0b1dae0abc3b19ef28901bb88cb3b74354fae3154bfeb6263ea"
    sha256 cellar: :any, big_sur:       "a76ed8448c933033ee273bc00dbfbe7b04e51b0320704951414fb18f336d5e71"
    sha256 cellar: :any, catalina:      "4f925752d8fdde0cd5c7bf1cb3056a31291e7c21a336b1478fdb0d788511bede"
    sha256 cellar: :any, mojave:        "b19dede26586fe43df5e299f281deb242a976da828b2f492e554bc1cffab8a5f"
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
