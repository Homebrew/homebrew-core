class Lxc < Formula
  desc "CLI client for interacting with LXD"
  homepage "https://ubuntu.com/lxd"
  url "https://github.com/canonical/lxd/releases/download/lxd-5.21.0/lxd-5.21.0.tar.gz"
  sha256 "be787ef099b83a583e55d00fa466e82d26c285d9f0b14f38220cb319ee25b60f"
  license "AGPL-3.0-only"
  head "https://github.com/canonical/lxd.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a7a92466c39e3c6ee8d4710343055be338f237600ee70a2c2f921132d89de6ff"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "56daad26bc8395e3d091fc070ada854484d1ba6103c4ddcfc5b2f7ae65f7308b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "df471905a1d9e4e692894848f2abac683e69fd1e51da6b95fd5474419d277d29"
    sha256 cellar: :any_skip_relocation, sonoma:         "02f6a552d4212ed0894227b711d661020db73e111fda05141e9e109d5aeba1b3"
    sha256 cellar: :any_skip_relocation, ventura:        "e3a672baa9abb0fe4824cbc95088e106977f8667b2d05adc129cb624dd587533"
    sha256 cellar: :any_skip_relocation, monterey:       "14ff8221544cdca10f65b4ce6b8c684f09fe419aa230fcab7e30dd580728fe86"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "75bf708b8db3f53720495467fe212e8820ffe057f246c2ca8856458a3a1460ed"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./lxc"
  end

  test do
    output = JSON.parse(shell_output("#{bin}/lxc remote list --format json"))
    assert_equal "https://cloud-images.ubuntu.com/releases", output["ubuntu"]["Addr"]

    assert_match version.to_s, shell_output("#{bin}/lxc --version")
  end
end
