class Opa < Formula
  desc "Open source, general-purpose policy engine"
  homepage "https://www.openpolicyagent.org"
  url "https://github.com/open-policy-agent/opa/archive/v0.17.3.tar.gz"
  sha256 "998e6af2ed46f30324e004e075bd18ed9918159de6ddf4ac19ff2b2972ead9fb"

  bottle do
    cellar :any_skip_relocation
    sha256 "2b5307c0a967e0d72424057ac2635b7f7e73f55e9c5cf7eda85c6ddbc7a6da8f" => :catalina
    sha256 "bd6a1eaa896759d236266ea734f5422e7181e21121457ded54ca282ea7031c43" => :mojave
    sha256 "4586682470ed89e2ebdab588adeeac5fe23bc32e2af940d92b89870f5b9bbda1" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-o", bin/"opa", "-trimpath", "-ldflags",
                 "-X github.com/open-policy-agent/opa/version.Version=#{version}"
    prefix.install_metafiles
  end

  test do
    output = shell_output("#{bin}/opa eval -f pretty '[x, 2] = [1, y]' 2>&1")
    assert_equal "+---+---+\n| x | y |\n+---+---+\n| 1 | 2 |\n+---+---+\n", output
    assert_match "Version: #{version}", shell_output("#{bin}/opa version 2>&1")
  end
end
