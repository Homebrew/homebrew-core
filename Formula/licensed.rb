# Documentation: https://docs.brew.sh/Formula-Cookbook
#                https://rubydoc.brew.sh/Formula
class Licensed < Formula
  desc "A Ruby gem to cache and verify the licenses of dependencies"
  homepage "https://github.com/github/licensed"
  url "https://github.com/github/licensed.git",
      tag:      "3.7.3",
      revision: "76727f75d486a24758890a030e540ebf87bba78b"
  license "MIT"

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build

  uses_from_macos "ruby"

  def install
    # ENV.deparallelize  # if your formula fails when building in parallel
    ENV["GEM_HOME"] = libexec
    system "gem", "build", "licensed.gemspec"
    system "gem", "install", "licensed-#{version}.gem"
    bin.install libexec/"bin/licensed"
    bin.env_script_all_files(libexec/"bin", GEM_HOME: ENV["GEM_HOME"])
  end

  test do
    assert_equal "#{version}", shell_output("#{bin}/licensed version").strip
  end
end
