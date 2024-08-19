class Gitu < Formula
  desc "TUI Git client inspired by Magit"
  homepage "https://github.com/altsem/gitu"
  url "https://github.com/altsem/gitu/archive/refs/tags/v0.24.0.tar.gz"
  sha256 "d6890a10af88c0a13b05ed00c6f656413422ea0cd63364ebfa346ca76796aadc"
  license "MIT"
  head "https://github.com/altsem/gitu.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a5c41d23aa1a460210c71436c302e9ade293b2060f8da81ff2e4a5a23716d75d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d29dde70d33bef3874eab3ce19866f0b31fcd09abcb911d3d1c5d8588e87eaf2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0ca5445008edc82bcb3640efa13a4d02dd47f86f120fee523d57668d5ccda2ac"
    sha256 cellar: :any_skip_relocation, sonoma:         "3a77dcb8e66f5fb9a6946a4ea1ab2489f261a5b29450dd5131c47fb988449297"
    sha256 cellar: :any_skip_relocation, ventura:        "7db6d4ba7b6c0f9b709f943ca5d18872da7d7460813d3d8d1c6b04a9d0c8c4f3"
    sha256 cellar: :any_skip_relocation, monterey:       "5240a3358261509b88fb619b9a4045968ce88290c0cc26435bb2d6d5ac974659"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5e04baab1a6d46a85da3a71c1a1fe66e55535bf027679df02d09dd4e2473c7e2"
  end

  depends_on "rust" => :build

  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gitu --version")

    output = shell_output(bin/"gitu 2>&1", 1)
    if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]
      assert_match "No such device or address", output
    else
      assert_match "No .git found in the current directory", output
    end
  end
end
