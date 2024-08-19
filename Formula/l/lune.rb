class Lune < Formula
  desc "Standalone Luau script runtime"
  homepage "https://lune-org.github.io/docs"
  url "https://github.com/lune-org/lune/archive/refs/tags/v0.8.7.tar.gz"
  sha256 "d3086455523f51ede379b3c81bfc1b932e077ef2a6a99c53cbaf0f137e4a3fdc"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "aa5b2c4e477b5dbefb4780886fc1dcf3db93ded8d49f21df1fb0b5ea22e19b46"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6e406985824ee983fb5a7880852e5518e9f2b9a18bc99635f1d667c8af05f750"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2197cadd3623610cf0697d553e75dcc555a2548973447bdf1c9e72d29b1944e7"
    sha256 cellar: :any_skip_relocation, sonoma:         "eca053a171e8e7a51802ccbe1bae6e39d4856b19958f347ef81c187a84209be8"
    sha256 cellar: :any_skip_relocation, ventura:        "e32eefe5f8663c84d15e6acfb90ff7e72fe336973c3b8dba80cf8304776feff8"
    sha256 cellar: :any_skip_relocation, monterey:       "c7d12a0199d5b776a9dc00da485a71b65d0d7613f72ff5ffecc241dabc0de336"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f798287ba22ef797091f25e4b41ca759b31e48d53ebbd3bab7a1b6e571e6370e"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", "--all-features", *std_cargo_args(path: "crates/lune")
  end

  test do
    (testpath/"test.lua").write("print(2 + 2)")
    assert_equal "4", shell_output("#{bin}/lune run test.lua").chomp
  end
end
