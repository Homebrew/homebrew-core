class Commandbox < Formula
  desc "CFML embedded server, package manager, and app scaffolding tools"
  homepage "https://www.ortussolutions.com/products/commandbox"
  url "https://downloads.ortussolutions.com/ortussolutions/commandbox/5.5.0/commandbox-bin-5.5.0.zip"
  sha256 "6fef820e8366d40cb8c322a8d132d2bd46d4444ad28cfc41a57bbe0d7da0b343"
  license "LGPL-3.0-or-later"

  livecheck do
    url :homepage
    regex(/Download CommandBox v?(\d+(?:\.\d+)+)/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "5dd25d2c17c758ee444ea547bec581a3d84f43d73fecb96e94eafd7c22780700"
  end

  # not yet compatible with Java 17 on ARM
  depends_on "openjdk@11"

  resource "apidocs" do
    url "https://downloads.ortussolutions.com/ortussolutions/commandbox/5.5.0/commandbox-apidocs-5.5.0.zip"
    sha256 "d6a1c261154c1f898c0f93dc2ee210603f4e22a3ed657bba595c17a5127202b4"
  end

  def install
    (libexec/"bin").install "box"
    (bin/"box").write_env_script libexec/"bin/box", Language::Java.java_home_env("11")
    doc.install resource("apidocs")
  end

  test do
    system "#{bin}/box", "--commandbox_home=~/", "version"
    system "#{bin}/box", "--commandbox_home=~/", "help"
  end
end
