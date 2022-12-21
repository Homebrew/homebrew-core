class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.196.2.tar.gz"
  sha256 "3e8213da9861bed8e0d278ac72dab6674c9bf30baa00061a5fd77eae9539aa26"
  license "MIT"
  head "https://github.com/facebook/flow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "00c90fb67dc8313233f5039bf8faf5c7a5114223739a0d594d2d7a2781f96ab0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "337b2b1c82228edd275c6b2268ea7ada5ca375aaef8c8db5668d195faa0ff2c2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9cc9dd977be378090834437de95fe42b3aba0c6344e4cb45312dd81e93271746"
    sha256 cellar: :any_skip_relocation, ventura:        "856d16369d4f6e38e84c95aa15aa2c43fbd77e15d9252f647f3f6bade0fd5fdd"
    sha256 cellar: :any_skip_relocation, monterey:       "e4b82942c6fd9d74ef37fde842325b79efaccb8b8a3d9f8edc1c2d32b52155c0"
    sha256 cellar: :any_skip_relocation, big_sur:        "ad7e11edf16062dc9498776519ac1547e89dda65ee8ea564a0559be14f08fc64"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "689de13a1782e4af6f9ca058149ce475b17a64c021c0e96d17c310885e583cb4"
  end

  depends_on "ocaml" => :build
  depends_on "opam" => :build

  uses_from_macos "m4" => :build
  uses_from_macos "rsync" => :build
  uses_from_macos "unzip" => :build

  def install
    system "make", "all-homebrew"

    bin.install "bin/flow"

    bash_completion.install "resources/shell/bash-completion" => "flow-completion.bash"
    zsh_completion.install_symlink bash_completion/"flow-completion.bash" => "_flow"
  end

  test do
    system "#{bin}/flow", "init", testpath
    (testpath/"test.js").write <<~EOS
      /* @flow */
      var x: string = 123;
    EOS
    expected = /Found 1 error/
    assert_match expected, shell_output("#{bin}/flow check #{testpath}", 2)
  end
end
