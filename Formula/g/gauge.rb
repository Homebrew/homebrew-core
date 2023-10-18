class Gauge < Formula
  desc "Test automation tool that supports executable documentation"
  homepage "https://gauge.org"
  url "https://github.com/getgauge/gauge/archive/v1.5.4.tar.gz"
  sha256 "1cdb85854afdeee380afe70228184167be378e94151b2a9faf9a4a3ee35d0242"
  license "Apache-2.0"
  head "https://github.com/getgauge/gauge.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "53dc445f7b4b27539579227805232a558bfeca76acaff3324f10f28dc6deb844"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "94ac8bfeda745226340c88ca6a60ba3c12e6ca778ff2e148251f338dcada7f9d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "036ff550d7bd1c69c5045f9fbdec439709b6bad455f419393e4ee747884c1ac8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4343ea4eeebe8f843303eeb925a9db8c64eb93cf57611a33ef86ee0521506f02"
    sha256 cellar: :any_skip_relocation, sonoma:         "78b171de075f4c9d82c06accc86b4cb7f0e0a3d88f6fac1aa99ff0ef501930f3"
    sha256 cellar: :any_skip_relocation, ventura:        "7ebc22023f0ac904b212a02cfa0e9b5183772fd0896bf24a65467b312193272d"
    sha256 cellar: :any_skip_relocation, monterey:       "6767f283852c19e19c71ffccd59459c82c3b87e7eaab8a651dd241368bb86da1"
    sha256 cellar: :any_skip_relocation, big_sur:        "4f61ec8e15a02458caace2cc942ea447b9749283d52403216429daab14f9107e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "22268ff698cfd1ac4eed89097a1e9d1c95bc9fadc26e896dfe8b90c89478b1a4"
  end

  depends_on "go" => :build

  def install
    system "go", "run", "build/make.go"
    system "go", "run", "build/make.go", "--install", "--prefix", prefix
  end

  test do
    (testpath/"manifest.json").write <<~EOS
      {
        "Plugins": [
          "html-report"
        ]
      }
    EOS

    system("#{bin}/gauge", "install")
    assert_predicate testpath/".gauge/plugins", :exist?

    system("#{bin}/gauge", "config", "check_updates", "false")
    assert_match "false", shell_output("#{bin}/gauge config check_updates")

    assert_match version.to_s, shell_output("#{bin}/gauge -v 2>&1")
  end
end
