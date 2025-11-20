class Binocle < Formula
  desc "Graphical tool to visualize binary data"
  homepage "https://github.com/sharkdp/binocle"
  url "https://github.com/sharkdp/binocle/archive/refs/tags/v0.3.2.tar.gz"
  sha256 "b58d450f343539242b9f146606f5e70d0d183e12ce03e1b003c5197e6e41727b"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/sharkdp/binocle.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0424cbc18de1317d37bd6716b7923f617c800b2bf4afaca3284cdd37dab4e795"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ed724155e7422f1dbdb1336e55beb128771c94d7508824dd3218a2aa4f833b05"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "20c6213d9ae44a09f4221194c23db04c0b549ae1c5ec688fc1f7b951ddbeab53"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6890ababd81453d26246f912140a9018174c7819a9c2b597a9663c9cdfb6d255"
    sha256 cellar: :any_skip_relocation, sonoma:        "d55ffda75e2ed88f3230d2769438cc207fdb099a96abb635d9748415fa275396"
    sha256 cellar: :any_skip_relocation, ventura:       "a9ee501f778c26b5f3f27c9aefbc63d2d82e019dd3d81f0339f63060a9947d4c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2a19bfb4cba506bee5c78b864bb52473611d58d1356e51371573c2235180c839"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5b316af1ebdf59111913cbb1bbe8836075316c7ebff977ebe12467815dfcf1ac"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "libx11"
    depends_on "libxcursor"
    depends_on "libxrandr"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/binocle --version")

    # Fails in Linux CI with
    # "Failed to initialize any backend! Wayland status: XdgRuntimeDirNotSet X11 status: XOpenDisplayFailed"
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    expected = if Hardware::CPU.arm?
      "Error: No such file or directory"
    else
      "Error: No suitable `wgpu::Adapter` found."
    end

    assert_match expected, shell_output("#{bin}/binocle test.txt 2>&1", 1)
  end
end
