class Delve < Formula
  desc "Debugger for the Go programming language"
  homepage "https://github.com/go-delve/delve"
  url "https://github.com/go-delve/delve/archive/refs/tags/v1.22.0.tar.gz"
  sha256 "826b0623ba054a4c212509b89794864864022a6996bab7df3739870938876c47"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "aac65ce53f5f57aae582da90ddc2557948169b20a2850839d6b96c37e6f46ef2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "96da9f38d1ee03fcaa0aacabe20688582045af0d44eb9dd9914c27853ab70948"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4326c60e2e592f397f4a73baeca36be96bc24d1365df995f057f642e70e29865"
    sha256 cellar: :any_skip_relocation, sonoma:         "43dd2e38e6f8c9d6ef178e795182a65041c8ad95e286cc661269c739b203b934"
    sha256 cellar: :any_skip_relocation, ventura:        "9d71bb8afb806256b88ec137441853a8b832d77dfbc0916cf98ce2d26eb42728"
    sha256 cellar: :any_skip_relocation, monterey:       "5e1822adc8de67506bab9c0c0ce5c6bbdd6efea54fce49ad24e222aa9515ff8c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1970f570bef83163dc9c7c8cc96ebcee4bc7bf1d7a49bbf0efe2559e9f145246"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(output: bin/"dlv"), "./cmd/dlv"
  end

  test do
    assert_match(/^Version: #{version}$/, shell_output("#{bin}/dlv version"))
  end
end
