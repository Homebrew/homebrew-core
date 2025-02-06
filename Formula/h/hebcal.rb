class Hebcal < Formula
  desc "Perpetual Jewish calendar for the command-line"
  homepage "https://github.com/hebcal/hebcal"
  url "https://github.com/hebcal/hebcal/archive/refs/tags/v5.9.0.tar.gz"
  sha256 "236617ad37c7621e61eb4aa10e407cf95950563bf5e0c663e4720e5a9fb5e3dd"
  license "GPL-2.0-or-later"
  head "https://github.com/hebcal/hebcal.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0a4a6970a6e0656faf5030875dc9e473004ce20e6948e09048f6d674f65e3bd2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0a4a6970a6e0656faf5030875dc9e473004ce20e6948e09048f6d674f65e3bd2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0a4a6970a6e0656faf5030875dc9e473004ce20e6948e09048f6d674f65e3bd2"
    sha256 cellar: :any_skip_relocation, sonoma:        "9db84c2ee5ff902d51984eaaf68f35199556b7cdd75d62c330fe4fe9ab01e394"
    sha256 cellar: :any_skip_relocation, ventura:       "9db84c2ee5ff902d51984eaaf68f35199556b7cdd75d62c330fe4fe9ab01e394"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e79fc6d26d27e5f0cb46f202f91556adde8b2648dc9d9d404d289b3139a1aec0"
  end

  depends_on "go" => :build

  def install
    # populate DEFAULT_CITY variable
    system "make", "dcity.go"
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    output = shell_output("#{bin}/hebcal 01 01 2020").chomp
    assert_equal output, "1/1/2020 4th of Tevet, 5780"
  end
end
