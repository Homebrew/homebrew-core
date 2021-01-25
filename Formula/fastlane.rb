class Fastlane < Formula
  desc "Easiest way to build and release mobile apps"
  homepage "https://fastlane.tools"
  url "https://github.com/fastlane/fastlane/archive/2.172.0.tar.gz"
  sha256 "09653f41f43814dbfb58d0d7e82a3b49a550d404fa6d4f37f23b4d110dfc0859"
  license "MIT"
  head "https://github.com/fastlane/fastlane.git"

  livecheck do
    url :head
    regex(/^([\d.]+)$/i)
  end

  bottle do
    cellar :any
    sha256 "f40121e1c323fecb0c6595761ba15674736863d3a7299d1a4d7440f9bef00277" => :big_sur
    sha256 "c04de95af044dd37f4d657d40d27663ca58e24a5b482fffc1fe475586228d5ca" => :arm64_big_sur
    sha256 "beebe5c5fe53f942437727398218574c9dc7f86e8cd7c73a3164b7fe0ab88dd7" => :catalina
    sha256 "eeaeb3dbf3490b81aa0d6a085f5076778e61f566f4876c1d2c87adc022a3a210" => :mojave
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
