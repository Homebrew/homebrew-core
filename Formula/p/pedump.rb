class Pedump < Formula
  desc "Dump Windows PE files using Ruby"
  homepage "https://pedump.me"
  url "https://github.com/zed-0xff/pedump/archive/refs/tags/v0.6.10.tar.gz"
  sha256 "fd31800d4e1e6d3cf0116b9b1a5565cde4bfc684bea3bab5a39b58745b44c3f6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "dc02ff28da3bafa97e0b32037e3d7d0a7d99ef2ce50f05b1e03e483be7c95465"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "16f4f904a046312881217b845df472a4a45f9f0caa7b2b1405b201fd952e8add"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "16f4f904a046312881217b845df472a4a45f9f0caa7b2b1405b201fd952e8add"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "16f4f904a046312881217b845df472a4a45f9f0caa7b2b1405b201fd952e8add"
    sha256 cellar: :any_skip_relocation, sonoma:         "185e205f37c88a84ab0e0fcd65b2415ff0a1a34980dadc27b4a104f287fd9677"
    sha256 cellar: :any_skip_relocation, ventura:        "185e205f37c88a84ab0e0fcd65b2415ff0a1a34980dadc27b4a104f287fd9677"
    sha256 cellar: :any_skip_relocation, monterey:       "185e205f37c88a84ab0e0fcd65b2415ff0a1a34980dadc27b4a104f287fd9677"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eef22f866ba629a7e7c382057c48f5784da5ad7756a34b2d334d24c9c380e7f8"
  end

  depends_on "ruby"

  conflicts_with "mono", because: "both install `pedump` binaries"

  def install
    ENV["GEM_HOME"] = libexec
    system "bundle", "config", "set", "without", "development"
    system "bundle", "install"
    system "gem", "build", "#{name}.gemspec"
    system "gem", "install", "--ignore-dependencies", "#{name}-#{version}.gem"
    bin.install libexec/"bin/#{name}"
    bin.env_script_all_files(libexec/"bin", GEM_HOME: ENV["GEM_HOME"])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pedump --version")

    resource "notepad.exe" do
      url "https://github.com/zed-0xff/pedump/raw/master/samples/notepad.exe"
      sha256 "e4dce694ba74eaa2a781f7696c44dcb54fed5aad337dac473ac8a6b77291d977"
    end

    resource("notepad.exe").stage testpath
    assert_match "2008-04-13 18:35:51", shell_output("#{bin}/pedump --pe notepad.exe")
  end
end
