class Fastlane < Formula
  desc "Easiest way to build and release mobile apps"
  homepage "https://fastlane.tools"
  url "https://github.com/fastlane/fastlane/archive/2.141.0.tar.gz"
  sha256 "18b81899aedf2591a883ae96ab3722664bfba5a855472d82ce43b57eb9811bd6"
  head "https://github.com/fastlane/fastlane.git"

  bottle do
    cellar :any
    sha256 "edaa4732dc51999cc430f630c70c473e5e53fe9352c4492dc256a9cabdf23b09" => :catalina
    sha256 "a4152196baf0bb412cbe82f3f5f5fb3373a5bd9bf94d9163b540eee88761cb64" => :mojave
    sha256 "4349b66ec9307f2faf7245de36216db656b059525d322d91a82b3cfd1d51433d" => :high_sierra
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
