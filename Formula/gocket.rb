class Gocket < Formula
  desc "CLI / TUI for Pocket"
  homepage "https://github.com/Phantas0s/gocket"
  url "https://github.com/Phantas0s/gocket/archive/refs/tags/v0.2.4.tar.gz"
  sha256 "c08bea2234b54cd6a8a68513f775c92985519c31f80cc7ed26b36d1556a6be41"
  license "Apache-2.0"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    require "open3"
    output = shell_output("#{bin}/gocket list 2&>1", 1)
    assert_include "List your Pocket pages", output
    assert_include "You need a pocket consumer key", output

    Open3.popen3("#{bin}/gocket -k 'nonexistent' list") do |*, stderr, wait_thr|
      assert_equal wait_thr.value.exitstatus, 2
      assert_include stderr.read, "Invalid consumer key"
    end
  end
end
