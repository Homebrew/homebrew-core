class Ioctl < Formula
  desc "Command-line interface for interacting with the IoTeX blockchain"
  homepage "https://docs.iotex.io/"
  url "https://github.com/iotexproject/iotex-core/archive/refs/tags/v2.2.1.tar.gz"
  sha256 "4eba51523829d49c236c64140f7d8ec051f174dd5797bc35e4d3a413953b4526"
  license "Apache-2.0"
  head "https://github.com/iotexproject/iotex-core.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "03653699ad4d3ef4410963127f9115241a897b164a0e5ea7c91aecac25225e03"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3690ff7cc280480301469fe0672690a01fec2611464b92cbb8388e432f38d0e1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "66fefd09c3ec1a89e7813e1209e22e6d04e8e58cc409854ea89978431d5448c8"
    sha256 cellar: :any_skip_relocation, sonoma:        "4f5f4178d9e7cbf5e51c619d302ff9db6feab9ffc122d5d534b5b88d72acd318"
    sha256 cellar: :any_skip_relocation, ventura:       "0e170d305460a2e9a624b098b9aae7010e84510c20993eba45ddd8d188ec2526"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "707f0ae8c295472b404367e6fda13980d95eb93af3f46c789c85d7616a5f1432"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "00efc183f30b6dbc5fd060a67d240524d4072ba853538bd821e2bb17a33e4361"
  end

  depends_on "go" => :build

  def install
    system "make", "ioctl"
    bin.install "bin/ioctl"
  end

  test do
    output = shell_output "#{bin}/ioctl config set endpoint api.iotex.one:443"
    assert_match "Endpoint is set to api.iotex.one:443", output
  end
end
