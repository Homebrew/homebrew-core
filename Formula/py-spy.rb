class PySpy < Formula
  desc "Sampling profiler for Python programs"
  homepage "https://github.com/benfred/py-spy"
  url "https://github.com/benfred/py-spy/archive/refs/tags/v0.3.8.tar.gz"
  sha256 "9dbfd0ea79ef31a2966891e86cf6238ed3831938cf562e71848e07b7009cf57d"
  license "MIT"
  head "https://github.com/benfred/py-spy.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "22121c8eaec4a7cd913ae2add7287df36ad0e9a32f8f3a141faeef12401672cc"
    sha256 cellar: :any_skip_relocation, big_sur:       "4dffb9d38caafb69e1bb3f3183a668102679b17824205a6a54e55966713cfcd5"
    sha256 cellar: :any_skip_relocation, catalina:      "915ac43c4c40dbac5d0abf7c014a335264d0d34e1d36e6f5eefc02147a296375"
    sha256 cellar: :any_skip_relocation, mojave:        "58015a69ab226cdbb2a2a28d9094cd9b90c23743aee394566e86c63f3cbc128c"
  end

  depends_on "rust" => :build
  depends_on "python@3.9" => :test

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}/py-spy record python3.9 2>&1", 1)
    assert_match "This program requires root", output
  end
end
