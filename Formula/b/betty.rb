class Betty < Formula
  desc "English-like interface for the command-line"
  homepage "https://github.com/pickhardt/betty"
  url "https://github.com/pickhardt/betty/archive/refs/tags/v0.1.7.tar.gz"
  sha256 "ed71e88a659725e0c475888df044c9de3ab1474ff483f0a3bb432949035e62d3"
  license "Apache-2.0"
  revision 1

  bottle do
    rebuild 3
    manifest_sha256 "6b4ec2052d53a4aad6c26d4fd189bc7c9295a4a8eb68c77c3c6379887a7878f7"
    sha256 cellar: :any_skip_relocation, all: "28ca7fb487aa98f4d03e4cfdd2544c281fdc152fbf79d72beec610945da4ce60"
  end

  depends_on "ruby"

  deny_network_access!

  def install
    libexec.install "lib", "main.rb" => "betty"
    bin.write_exec_script libexec/"betty"
  end

  test do
    system bin/"betty", "what is your name"
    system bin/"betty", "version"
  end
end
