class Landrun < Formula
  desc "Lightweight, secure sandbox for running Linux processes using Landlock LSM"
  homepage "https://github.com/Zouuup/landrun"
  url "https://github.com/Zouuup/landrun/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "1ec505759bd83084af595d20e8296731c9fc94e7225c711c927fdd72984df256"
  license "MIT"

  bottle do
    manifest_sha256 "3a4eb264306ee4bbcadb55be703abcc52d85b17fcf27ab32420b2e24a46c6851"
    sha256 cellar: :any_skip_relocation, arm64_linux:  "b215d2a1e29f83981816d4c89c93dcdf929ed871f2c9bccf256954759c50179c"
    sha256 cellar: :any,                 x86_64_linux: "d873f13b8f0ac301014cfc2b51296e4cb063cfdbfa9c16f85b30a0cc5b5b8b86"
  end

  depends_on "go" => :build
  depends_on :linux

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args, "./cmd/landrun"
  end

  test do
    lib_paths = %w[/lib /usr/lib /lib64 /usr/lib64].select { |dir| File.directory? dir }
    output = shell_output("#{bin}/landrun --rox /usr --ro #{lib_paths.join(",")} --best-effort -- pwd")
    assert_equal output.chomp, testpath.to_s
  end
end
