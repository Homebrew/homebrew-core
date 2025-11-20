class IntelliShell < Formula
  desc "Like IntelliSense, but for shells"
  homepage "https://lasantosr.github.io/intelli-shell/"
  url "https://github.com/lasantosr/intelli-shell/archive/refs/tags/v3.3.0.tar.gz"
  sha256 "d39b9dfdcaa7537b51ad0af283a4c46e87f687a518657de725e68d316cbba0b9"
  license "Apache-2.0"
  head "https://github.com/lasantosr/intelli-shell.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d76ccec3bc031aaa14c7c67ed6eff2249fafb9182c65ec4c41bfda8ab9a8b712"
    sha256 cellar: :any,                 arm64_sequoia: "84b8db57401d9f3da44a060ed9782d609a9c515334f271c51d5b48296797da34"
    sha256 cellar: :any,                 arm64_sonoma:  "9f47e29fd3185f63a8ca8917939e313c33e2de4fa2ffcafffda140f10e9630b0"
    sha256 cellar: :any,                 sonoma:        "e51e5e450847504203c054dc8b0a5aa815ce4eb7cbe8ace1f6432c445ebc753c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "26662996b05f84b80342e5271618fb2993dc542e8e7e504a07b7c8e1e33f18e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7506a29fa4a1d1dd381bfe6bc23f817ae57be8d8a6f30f48dbb89fd3d862578e"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/intelli-shell --version")

    system bin/"intelli-shell", "config", "--path"

    output = shell_output("#{bin}/intelli-shell export 2>&1", 1)
    assert_match "[Error] No commands or completions to export", output
  end
end
