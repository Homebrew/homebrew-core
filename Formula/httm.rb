class Httm < Formula
  desc "Interactive, file-level Time Machine-like tool for ZFS/btrfs"
  homepage "https://github.com/kimono-koans/httm"
  url "https://github.com/kimono-koans/httm/archive/refs/tags/0.23.0.tar.gz"
  sha256 "8dfad3b0e668eb2db03b493a464969de9f7d52b4442c024551b58795d9489374"
  license "MPL-2.0"
  head "https://github.com/kimono-koans/httm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "495aea803dcb07b6df565f8e3aada5322b710f673543281721f9f846de7e8cec"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c3b5d2051eaf01caa7a306ee1fac44e4337a775b4bf0f23fe8c7959e1ddad066"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fc4a85362a93d92d12e657c553daea00cad035e6fad6dac3bda2239beb90c6e8"
    sha256 cellar: :any_skip_relocation, ventura:        "148039a615f9cfeff364963ea01380529f1042b9b3f85df6be9fee0db088ebb0"
    sha256 cellar: :any_skip_relocation, monterey:       "15d32edefaf8880da2c1fb02879ee5b238b1ad99e22ca3c8652e0bccad6d485e"
    sha256 cellar: :any_skip_relocation, big_sur:        "10ad841e2987d93d598cc36e401fd591bf0116ac37b6efe3c122cd61dc538e2a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "233f4a5bdd3414fd88a7b9e90a5da033c2440b7412ec011e296e6640e7148001"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    man1.install "httm.1"
  end

  test do
    touch testpath/"foo"
    assert_equal "Error: httm could not find any valid datasets on the system.",
      shell_output("#{bin}/httm #{testpath}/foo 2>&1", 1).strip
    assert_equal "httm #{version}", shell_output("#{bin}/httm --version").strip
  end
end
