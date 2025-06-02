class Cariddi < Formula
  desc "Scan for endpoints, secrets, API keys, file extensions, tokens and more"
  homepage "https://github.com/edoardottt/cariddi"
  url "https://github.com/edoardottt/cariddi/archive/refs/tags/v1.4.1.tar.gz"
  sha256 "d5870e294b7d9831fd95c19592bc5e5b615a6e07e9bba1139e288b42ddf5005f"
  license "GPL-3.0-or-later"
  head "https://github.com/edoardottt/cariddi.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "555e2c1c4a8822693a892cd12864a14287d573c0763d9ce1118bdfbb5dededd8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "555e2c1c4a8822693a892cd12864a14287d573c0763d9ce1118bdfbb5dededd8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "555e2c1c4a8822693a892cd12864a14287d573c0763d9ce1118bdfbb5dededd8"
    sha256 cellar: :any_skip_relocation, sonoma:        "14b27df41f87d2aeae0921217024e697a8393ff819aca20a3398f5cc6c20f7f0"
    sha256 cellar: :any_skip_relocation, ventura:       "14b27df41f87d2aeae0921217024e697a8393ff819aca20a3398f5cc6c20f7f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9c6f84faaaf6a4c14858e01f31d05e27436aa3745d64ebfb544fa9eed54e160d"
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
