class Jot < Formula
  desc "Rapid note management for the terminal"
  homepage "https://github.com/shashwatah/jot"
  url "https://github.com/shashwatah/jot/archive/refs/tags/v0.1.2.tar.gz"
  sha256 "d7da3220c29102ee7c51e2a5656ceb6672ae3b85be22c5ddcd176b330c6029c9"
  license "MIT"
  head "https://github.com/shashwatah/jot.git", branch: "main"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "c2251981468647abc1ef8ea360bd2dac2ab585a4cbffb5563dc12afcb448fee8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "93a520809e6790b6d9c41fedf1ef0702112bad61affb1b23cf51c9d8ef030cc3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "beec04c6b8b43d679fc4bdfc9d079c2b4ae7fa6d07b526372f37fd56fa52b2b5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "763cda455c13e6b801488dbf52e57ddceddfbf5e24937f247545a44b37558460"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "652c81a8996f43e8c8bca51bffa6f2c27f2253aeb3b5d1280628d674de263a97"
    sha256 cellar: :any_skip_relocation, sonoma:         "75eb2d10462b9b9161c3a6830062fe83ec63907f53b2c1b1f42d11e44d532e62"
    sha256 cellar: :any_skip_relocation, ventura:        "4b7c7e29dff1a8057b628f43452439d02df492dee6e526269aca874f7158a883"
    sha256 cellar: :any_skip_relocation, monterey:       "a90a251a9a3a0644dd527374e199e13a70441b3a4020f0db95421b60995f4bb1"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "85fbebdda3af0b8454bb99e24e6151c2eed317242fc23f0e5737f90b0c446467"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f99f5f3de62fcb33cda952afcfabc511d11bc30614f0795d7d15808ea1b6c13b"
  end

  depends_on "rust" => :build

  conflicts_with "json-table", because: "both install `jt` binaries"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"jt", "vault", "testvault", testpath
    system bin/"jt", "enter", "testvault"

    system bin/"jt", "note", "testnote"
    assert_path_exists testpath/"testvault/testnote.md"

    system bin/"jt", "remove", "note", "testnote"
    refute_path_exists testpath/"testvault/testnote.md"
  end
end
