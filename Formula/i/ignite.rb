class Ignite < Formula
  desc "Build, launch, and maintain any crypto application with Ignite CLI"
  homepage "https://docs.ignite.com/"
  url "https://github.com/ignite/cli/archive/refs/tags/v29.5.0.tar.gz"
  sha256 "c563229b71ebbef48a942a4ab1bd41edcbe3adb354f2d75c43150fc88d943c14"
  license "Apache-2.0"
  head "https://github.com/ignite/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9d79e1eaf7b974aaa7dc505a3941af6b5b2619b0fcabd397e6632f9a58851863"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0f339fa290ab84310c7fda798e431879133b41758194e418b40e1d0d37d4141a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5ca15c0af2b63b8ed9c441e0430c3dc98f857d4f7267e85b18f8771420428cab"
    sha256 cellar: :any_skip_relocation, sonoma:        "c0571d0732c31c870b4b362c2f886f50932e0bf9f882eccfc423580bcc22702a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bb7ae6e98b774521412dfb534ee53ebbde3ec4a9d978caca2f27a143622a9639"
  end

  depends_on "go"
  depends_on "node"

  def install
    system "go", "build", "-mod=readonly", *std_go_args(ldflags: "-s -w", output: bin/"ignite"), "./ignite/cmd/ignite"
  end

  test do
    ENV["DO_NOT_TRACK"] = "1"
    system bin/"ignite", "s", "chain", "mars"
    sleep 2
    sleep 5 if OS.mac? && Hardware::CPU.intel?
    assert_path_exists testpath/"mars/go.mod"
  end
end
