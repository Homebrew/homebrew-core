class Gocket < Formula
  desc "CLI / TUI for Pocket"
  homepage "https://github.com/Phantas0s/gocket"
  url "https://github.com/Phantas0s/gocket/releases/download/v0.2.4/gocket_0.2.4_Darwin_x86_64.tar.gz"
  version "0.2.4"
  sha256 "971594be7b9b0efef3e68665a6d2a43dff1ea6cb7665725ea2a5212b9035186f"
  license "Apache-2.0"

  def install
    bin.install "gocket"
  end

  test do
    assert_predicate bin/"gocket", :exist?

    require "open3"
    Open3.popen3("#{bin}/gocket list") do |_, stdout, stderr, wait_thr|
      assert_include stdout.read, "List your Pocket pages"
      assert_include stderr.read, "You need a pocket consumer key"
      assert_equal wait_thr.value.exitstatus, 1
    end

    Open3.popen3("#{bin}/gocket -k 'nonexistent' list") do |*, stderr, wait_thr|
      assert_equal wait_thr.value.exitstatus, 2
      assert_include stderr.read, "Invalid consumer key"
    end
  end
end
