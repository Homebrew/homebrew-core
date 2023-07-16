class Httpsimctl < Formula
  desc "Command-line tool for interacting with iOS Simulators via the HTTP REST API"
  homepage "https://github.com/sschizas/HTTPsimctl"
  url "https://github.com/sschizas/HTTPsimctl/archive/refs/tags/1.0.0.tar.gz"
  sha256 "dfa12be19aeb86674080f41061cd8346bf26aa0cad15dd4d82c46fab678f6fa4"
  license "MIT"
  head "https://github.com/sschizas/HTTPsimctl.git", branch: "main"

  depends_on "vapor" => :build
  uses_from_macos "swift" => ["5.8", :build]

  def install
    system "swift", "build", "--disable-sandbox", "--configuration", "release"
    bin.install ".build/release/Run" => "httpsimctl"
  end

  test do
    assert_match "Usage: httpsimctl", shell_output("#{bin}/httpsimctl --help")
  end
end
