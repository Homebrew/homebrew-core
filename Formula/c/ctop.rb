class Ctop < Formula
  desc "Top-like interface for container metrics"
  homepage "https://bcicen.github.io/ctop/"
  url "https://github.com/bcicen/ctop.git",
      tag:      "v0.7.7",
      revision: "11a1cb10f416b4ca5e36c22c1acc2d11dbb24fb4"
  license "MIT"
  head "https://github.com/bcicen/ctop.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "4ddb01679cc99906cb9a7e87ce4784d8306356a4b80dbb50d2c325c7e43f893c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "cd09dd7c11239dd436500639b817a7c935a16033630cfc78b5f6a3acbb763089"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "217bb4ee91c955c570491fc44d7ed650854aaa3cb6e08f6269b33b1595bc36f0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "010e50edd98d6e9a43e3d4351281eae20f62df79a3f9d82d4da5309e2b30b2a4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cacf1e287ff25e701de9c1472d462377e8bf90cc5733defe595b5c0f5848ab64"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ec4b96f4c4eddacb20dbb142c430ed9b8ba975519e7b383eb0613bf7f62092a0"
    sha256 cellar: :any_skip_relocation, sonoma:         "76890ee3cbad12abb395444caa1d5a07e684f891e282dedf568e0eac14d422f9"
    sha256 cellar: :any_skip_relocation, ventura:        "45a367803950a7c4953b036d94c821a08b6229585ccfabd2134b4ef500753091"
    sha256 cellar: :any_skip_relocation, monterey:       "523a700771377a75e6da967df31d5f878d9a8ab52ab4412e10aa294ac183074f"
    sha256 cellar: :any_skip_relocation, big_sur:        "6dc1e0a2f6cb7fe27e7657e3bb0ba2825e8f730f4a1da6e98273f9f88aff0b2b"
    sha256 cellar: :any_skip_relocation, catalina:       "0a358054ae920a6c520fbee9fc3d3d18b5a78d12aa77918240ead37aa56fae1d"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "a4a567b1feba7fa72b0a76efbef9d14c8e7de8f3e4329109fa8c0338e058251d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "30607fe87d023df1ab88efe82c18af28e5276cfb8281de6b51bdedea41b5179e"
  end

  depends_on "go" => :build

  def install
    system "make", "build"
    bin.install "ctop"
  end

  test do
    system bin/"ctop", "-v"
  end
end
