class Argc < Formula
  desc "Easily create and use cli based on bash script"
  homepage "https://github.com/sigoden/argc"
  url "https://github.com/sigoden/argc/archive/refs/tags/v1.18.0.tar.gz"
  sha256 "1a171e581a2ec5f77109de1fc2970265eefc3aa792f55276e3ed73f8111a5939"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2937bb223acdbf082714c1e023443605c73092b91246e45413ff7fe9245c24a8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6edfe1d580a3c9dee8d4aea4b9ec5a4a479c35d9e15f9e15ff875b29f3d21f71"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "64232147c62b0a4f2e06b29b090ebcc4f007525821f8e434fd409cf01662d58f"
    sha256 cellar: :any_skip_relocation, sonoma:         "6ec6993ff229800596bda3fa0b635c03cfcb4953d9e786ee7c95400afb5382e0"
    sha256 cellar: :any_skip_relocation, ventura:        "bafefbb604b774ee53c647a10f62d2f311a53f62bae74328ab77cfa705489c9b"
    sha256 cellar: :any_skip_relocation, monterey:       "8b8e6dd35987d68e6a651dc5d1a297bf8c3516bcc609de46b6ab6978757ee990"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ede401f87ac7ab6c99afe3bb5a419653fb0950b1e39c5b4b10e411e8f6a1ec99"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"argc", "--argc-completions")
  end

  test do
    system bin/"argc", "--argc-create", "build"
    assert_predicate testpath/"Argcfile.sh", :exist?
    assert_match "build", shell_output("#{bin}/argc build")
  end
end
