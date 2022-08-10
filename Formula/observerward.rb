class Observerward < Formula
  desc "Cross platform community web fingerprint identification tool"
  homepage "https://0x727.github.io/ObserverWard/"
  url "https://github.com/0x727/ObserverWard/archive/refs/tags/v2022.8.10.tar.gz"
  sha256 "ee962483a8cf391651df21a8c8acda27aa7a5e4c782672ddf96a3324e715268d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7333aab6a4a96de8dfb8bfa2e73909da4cd2b65ad88562bf8ef495a3806e7689"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "90ba59e084398e3565b1aaab7e0832c143631e26295a5a23d3482fdd516b6763"
    sha256 cellar: :any_skip_relocation, monterey:       "2d9ddbac018c92c1356d599ba2989454709553ff0bce707b1f06e67f2c5570db"
    sha256 cellar: :any_skip_relocation, big_sur:        "e0ca00033b0bfab3d061f13a0b0f8772e0d848bf6f4431c3eeedada86d6f9974"
    sha256 cellar: :any_skip_relocation, catalina:       "359ee4bf8f3c6dec41c8a97996d1e8772212ad47c7842ec96d24977528665dae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6558cf4f8ccd0bdc05a2d15b4850ad956e7de48d3364d4624f21f1b98dea36ee"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"observer_ward", "-u"
    assert_match "swagger", shell_output("#{bin}/observer_ward -t https://httpbin.org")
  end
end
