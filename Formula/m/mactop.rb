class Mactop < Formula
  desc "Apple Silicon Monitor Top written in Golang"
  homepage "https://github.com/context-labs/mactop"
  url "https://github.com/context-labs/mactop/archive/refs/tags/v0.2.3.tar.gz"
  sha256 "37bc8567f66d31b0cbcdd7b39deee3fd0155cffbe65daba53044cbcd69d5dbfd"
  license "MIT"
  head "https://github.com/context-labs/mactop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dd7f16331f6a5bfab13fc8fc33ca1abc815409a7ab59317b75aa797c16e7897f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "764a410ff884d3dfec56671f410c8134b69c76faa6e2bfd864a3f30be4476dea"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bf7d1feea9cb49fde8e6f9d3b4675c49ea78dfdd5eeb8e6857fd448e643d85e7"
  end

  depends_on "go" => :build
  depends_on arch: :arm64
  depends_on :macos

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  def caveats
    <<~EOS
      mactop requires root privileges, so you will need to run `sudo mactop`.
      You should be certain that you trust any software you grant root privileges.
    EOS
  end

  test do
    test_input = "This is a test input for brew"
    assert_match "Test input received: #{test_input}", shell_output("#{bin}/mactop --test '#{test_input}'")
  end
end
