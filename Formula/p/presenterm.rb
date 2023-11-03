class Presenterm < Formula
  desc "Terminal slideshow tool"
  homepage "https://github.com/mfontanini/presenterm"
  url "https://github.com/mfontanini/presenterm/archive/refs/tags/v0.2.1.tar.gz"
  sha256 "3d0d80f13cbb13e8f1afc0fd4503f661835ac978ad730c8b57422b13d95657e0"
  license "BSD-2-Clause"
  head "https://github.com/mfontanini/presenterm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "dbfd23ec95da014d234e7752c1f8e3eeccc7a7ca30b90b8b9edd08cef9371e1d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "44ffff42482091b838ab1b2e038d9385a10d26e1db94b773d949e93de50705ad"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "95215065e83cfbdec3c67fb5b60cbb82ce2a42a2fede5bb2b04e815270db5a08"
    sha256 cellar: :any_skip_relocation, sonoma:         "0d8aa3fd94272cb7e34a61246a6d37909b6d74a658ca3bb8411f0fff482f2548"
    sha256 cellar: :any_skip_relocation, ventura:        "9659ec4a72ac0b12cf5c528f1ab0ae1237594f0bbdbee15cda65ea216db40bb7"
    sha256 cellar: :any_skip_relocation, monterey:       "eaae2d75c2dfe7040b9eddb705d00563cd4991a18f780692cdfb87fb7ad71488"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b491be7bd9a43af635687ae25dcbe6e46d1111a434c5f098fbc865eba92ae0ef"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}/presenterm non_exist.md 2>&1")
    assert_match "Failed to run presentation", output

    assert_match version.to_s, shell_output("#{bin}/presenterm --version")
  end
end
