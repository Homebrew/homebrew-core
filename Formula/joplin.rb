require "language/node"

class Joplin < Formula
  desc "Note taking and to-do application with synchronisation capabilities"
  homepage "http://joplin.cozic.net/"
  url "https://registry.npmjs.org/joplin/-/joplin-1.0.98.tgz"
  sha256 "48b0ea164ec999620735dd910153ca997c0b00917526c69209b2ed3735610845"

  bottle do
    sha256 "b02c19c7df50ffdcf564a98f8dcd39bfc5c217db294d560db751f3386c2dad57" => :high_sierra
    sha256 "abe64f000d306c6de277caa0901d8db75f517d52c60846a3959b8ed84a108044" => :sierra
    sha256 "1f085aebc104aac7d2be453c3699a4e1e82ac38e240a4bd835f0c72feeadfac4" => :el_capitan
  end

  depends_on "node"
  depends_on "python" => :build if MacOS.version <= :snow_leopard

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"joplin", "config", "editor", "subl"
    assert_match "editor = subl", shell_output("#{bin}/joplin config")
  end
end
