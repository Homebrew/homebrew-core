class Cocoapods < Formula
  desc "Dependency manager for Cocoa projects"
  homepage "https://cocoapods.org/"
  url "https://github.com/CocoaPods/CocoaPods/archive/1.3.0.tar.gz"
  sha256 "3911e36ca3b3cf443b984d0f802b76b21458db493e35f1427e032c83b8339635"

  bottle do
    cellar :any_skip_relocation
    sha256 "928c4313f4af25d4da3a801aeda63ec621483f4678ee32a7e07923ec0fac8e07" => :sierra
    sha256 "b9d99baf30717a70e6334d164fa74f6119d8e5c0ec9073b1c07dca70595e0633" => :el_capitan
    sha256 "d80d01c190d45c16cb18a4c79aef04ab7f2e686bb4bdd8163e2b8aa9270c791c" => :yosemite
  end

  def install
    ENV["GEM_HOME"] = libexec
    system "gem", "build", "cocoapods.gemspec"
    system "gem", "install", "cocoapods-#{version}.gem"
    # Other executables don't work currently.
    bin.install libexec/"bin/pod", libexec/"bin/xcodeproj"
    bin.env_script_all_files(libexec/"bin", :GEM_HOME => ENV["GEM_HOME"])
  end

  test do
    system "#{bin}/pod", "list"
  end
end
