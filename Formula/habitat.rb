class Habitat < Formula
  desc "Tool to create automation for applications"
  homepage "https://www.habitat.sh/"
  url "https://api.bintray.com/content/habitat/stable/darwin/x86_64/hab-0.8.0-20160708205701-x86_64-darwin.zip?bt_package=hab-x86_64-darwin"
  version "0.8.0-20160708205701"
  sha256 "0641a60618a5944a4b0952a1f10aefe0bb344bcd044600f9df25ab5dfe301f66"
  def install
    bin.install "hab"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hab --version 2>&1")
  end
end
