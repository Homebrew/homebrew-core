class Energy < Formula
  desc "Energy is a framework developed by Go language based on CEF (Chromium Embedded Framework) for developing cross-platform desktop applications for Windows, Mac OS X, and Linux"
  homepage "https://energye.github.io"
  url "https://github.com/energye/energy/archive/refs/tags/v2.4.5.tar.gz"
  sha256 "157beb93773637b75ffd0d72cc5ba3303d39065f6448b5272b5d9350da2eb47e"
  license "Apache-2.0"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/energy"
  end

  test do
    output = shell_output("#{bin}/energy cli -v 2>&1")
	assert_match "Current", output
	assert_match "Latest", output
	
    output = shell_output("#{bin}/energy env 2>&1")
	assert_match "Get ENERGY Framework Development Environment", output
	assert_match "GOROOT", output
	assert_match "ENERGY_HOME", output
  end
end
