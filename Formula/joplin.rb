require "language/node"

class Joplin < Formula
  desc "Note taking and to-do application with synchronisation capabilities"
  homepage "http://joplin.cozic.net/"
  url "https://registry.npmjs.org/joplin/-/joplin-0.10.82.tgz"
  sha256 "ceba5bea07f5c71a8a70bc951222d8631da497de7072f0ff5b25c338ef2f6b52"

  bottle do
    sha256 "b84032e4271bd89a61ecd09fbf21a9a3146b4393da624436c7df22edfd34e349" => :high_sierra
    sha256 "45f1c9106438cad753496518bf7d5c86180cb78af7eff69528dc89b591d3bc17" => :sierra
    sha256 "973ebae6edf16579a7915f51b42896c493a0d18ea1fe44b120b256699299a066" => :el_capitan
  end

  depends_on "node"
  depends_on :python => :build if MacOS.version <= :snow_leopard

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"joplin", "config", "editor", "subl"
    assert_match "editor = subl", shell_output("#{bin}/joplin config")
  end
end
