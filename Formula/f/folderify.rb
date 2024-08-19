class Folderify < Formula
  desc "Generate pixel-perfect macOS folder icons in the native style"
  homepage "https://github.com/lgarron/folderify"
  url "https://github.com/lgarron/folderify/archive/refs/tags/v4.0.0.tar.gz"
  sha256 "8a103f496cacc0fec72bb0d3847a630e38c49dba98dd334bbf89cb6273ec8b64"
  license "MIT"
  head "https://github.com/lgarron/folderify.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0219485b57420beaa462004c573c9fe8b55a56b3174e527f506adfdd216a28f1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "302dbc5c7cf6c8cba6f7dfb54361b0a0e81a54ca10ad43c5410ee40770f06c53"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cd4b774735fb5a2a8e318f19c438402c3b940164df49eb437b3b3fafa4aa4893"
    sha256 cellar: :any_skip_relocation, sonoma:         "ccd32e6a64d7325cb151b84b678737285322a329659ae32dc4706405d39e179b"
    sha256 cellar: :any_skip_relocation, ventura:        "5bb9b2ce71041402517f138f1e83fa829a8996d4a57d0cc715fa297eea8f41d3"
    sha256 cellar: :any_skip_relocation, monterey:       "028c0a48489a0ec026c236ab146ab56c8984c788e814bef94b606c7dde1d96ab"
  end

  depends_on "rust" => :build
  depends_on xcode: :build
  depends_on "imagemagick"
  depends_on :macos

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"folderify", "--completions")
  end

  test do
    # Write an example icon to a file.
    File.write("test.svg", '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100">
      <circle cx="50" cy="50" r="40" fill="transparent" stroke="black" stroke-width="20" /></svg>')

    # folderify applies the test icon to a folder
    system bin/"folderify", "test.svg", testpath.to_s
    # Tests for the presence of the file icon
    assert_predicate testpath / "Icon\r", :exist?
  end
end
