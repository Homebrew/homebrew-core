class MediaControl < Formula
  desc "Control and observe media playback from the command-line"
  homepage "https://github.com/ungive/media-control"
  # pull from git tag to get submodules
  url "https://github.com/ungive/media-control.git",
      tag:      "v0.2.0",
      revision: "f6c7293a8c6199f9ccc07c7d650737fb5d788001"
  license "BSD-3-Clause"
  head "https://github.com/ungive/media-control.git", branch: "master"

  depends_on "cmake" => :build
  depends_on :macos

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    output = shell_output("#{bin}/media-control get").strip
    parsed = JSON.parse(output)
    # The output is either null or a dictionary with at least the given keys.
    if parsed.nil?
      # ok
    else
      # Application bundle identifier
      assert parsed.is_a?(Hash)
      assert parsed.key?("bundleIdentifier")
      assert parsed["bundleIdentifier"].is_a?(String)
      assert !parsed["bundleIdentifier"].empty?
      # Media playback state
      assert parsed.key?("playing")
      assert parsed["playing"].is_a?(TrueClass) || parsed["playing"].is_a?(FalseClass)
      # Media title
      assert parsed.key?("title")
      assert parsed["title"].is_a?(String)
      assert !parsed["title"].empty?
    end
  end
end
