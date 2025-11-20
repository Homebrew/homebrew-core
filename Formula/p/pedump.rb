class Pedump < Formula
  desc "Dump Windows PE files using Ruby"
  homepage "https://pedump.me"
  url "https://github.com/zed-0xff/pedump/archive/refs/tags/v0.7.2.tar.gz"
  sha256 "878796667ffedeb77414b2c2989303bd0a0620d5d6ab22a91ee0ce5bd1445116"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "af986904946d2896e8f399748e74c635eb7a257722e2df3062b8591bd85f6020"
  end

  depends_on "ruby"

  conflicts_with "mono", because: "both install `pedump` binaries"

  def install
    ENV["BUNDLE_FORCE_RUBY_PLATFORM"] = "1"
    ENV["BUNDLE_VERSION"] = "system" # Avoid installing Bundler into the keg
    ENV["BUNDLE_WITHOUT"] = "development test"
    ENV["GEM_HOME"] = libexec

    system "bundle", "install"
    system "gem", "build", "#{name}.gemspec"
    system "gem", "install", "#{name}-#{version}.gem"

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
