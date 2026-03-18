class Ascelerate < Formula
  desc "Swift CLI for App Store Connect"
  homepage "https://github.com/keremerkan/ascelerate"
  url "https://github.com/keremerkan/ascelerate/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "8adca67fa03ee79092182a761105729eab09ca2d22935b6e74438cca171bec5b"
  license "MIT"

  depends_on xcode: ["15.0", :build]
  depends_on :macos

  def install
    system "swift", "build", "-c", "release", "--disable-sandbox"
    bin.install ".build/release/ascelerate"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ascelerate version")
  end
end
