class CargoBinstall < Formula
  desc "Binary installation for rust projects"
  homepage "https://github.com/cargo-bins/cargo-binstall"
  url "https://github.com/cargo-bins/cargo-binstall/archive/refs/tags/v1.9.0.tar.gz"
  sha256 "351e988b7118f1775fb86e8f29a9095fc3f96ea5ada4bcb2a2a3393a3a37c712"
  license "GPL-3.0-only"
  head "https://github.com/cargo-bins/cargo-binstall.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "dd5fc7222eddf7fd09a83d5603d9a0ca1859e5076cd312613d48f60e0644d884"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "efe13f1d68bc04e98f48d2d9e3a5013160c17c9b91b6849bc43191667abcfd62"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "83a3e1b7c0f8a6868828c1811a59b2e2f7df464a7fbd0a1a75836c930f1029fe"
    sha256 cellar: :any_skip_relocation, sonoma:         "4ff72f298b3940618f82a8694e02e69af0c968f4da68e503661baa9160b4d732"
    sha256 cellar: :any_skip_relocation, ventura:        "3f808e5f53c8eefb9ac6d6bb440eddf0f1c5b3aa1f941392beb2d277f2cb1b40"
    sha256 cellar: :any_skip_relocation, monterey:       "2913e69cc47cb7460cc2e81f4c0dc7eb02bd9a847998530674526fb54dc6e221"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2f17c572b4c114ff7cd976e3e92e36ba69088afe3abea306aa928d552eb67886"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/bin")
  end

  test do
    output = shell_output("#{bin}/cargo-binstall --dry-run radio-sx128x")
    assert_match "resolve: Resolving package: 'radio-sx128x'", output

    assert_equal version.to_s, shell_output("#{bin}/cargo-binstall -V").chomp
  end
end
