class Cariddi < Formula
  desc "Scan for endpoints, secrets, API keys, file extensions, tokens and more"
  homepage "https://github.com/edoardottt/cariddi"
  url "https://github.com/edoardottt/cariddi/archive/refs/tags/v1.4.3.tar.gz"
  sha256 "cc8d9202af6e13fc44a79e6d4380592df3c28bdf7c078a92ff0f62732b9c6882"
  license "GPL-3.0-or-later"
  head "https://github.com/edoardottt/cariddi.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "930d5513059d88f7ae9930d6a52c6b22740b7f7244e4026c72896be4c2f9ddfc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "930d5513059d88f7ae9930d6a52c6b22740b7f7244e4026c72896be4c2f9ddfc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "930d5513059d88f7ae9930d6a52c6b22740b7f7244e4026c72896be4c2f9ddfc"
    sha256 cellar: :any_skip_relocation, sonoma:        "f4220d6066dcc119d35932ccfd13cec1bed4ff528c480336e3d6f1f000b79ced"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0c598cf7c84333d0e659ad87d1c96f67b79fd5ab367eea1311eddb993cb45cda"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/cariddi"
  end

  test do
    output = pipe_output(bin/"cariddi", "http://testphp.vulnweb.com")
    assert_match "http://testphp.vulnweb.com/login.php", output

    assert_match version.to_s, shell_output("#{bin}/cariddi -version 2>&1")
  end
end
