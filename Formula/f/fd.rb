class Fd < Formula
  desc "Simple, fast and user-friendly alternative to find"
  homepage "https://github.com/sharkdp/fd"
  url "https://github.com/sharkdp/fd/archive/refs/tags/v10.1.0.tar.gz"
  sha256 "ee4b2403388344ff60125c79ff25b7895a170e7960f243ba2b5d51d2c3712d97"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/sharkdp/fd.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c3e0ec991e19f6031aa164974172581f626cd12d07a8b8378b3f31c6418bea26"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "15370c69b34b78e630f11c80adae1e84a9cb13e7f2e111c24eaa28e8846d35e6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "984caac0c2178fb500f599a0b43b3a13519b365408415254db8336eb0ee3c75a"
    sha256 cellar: :any_skip_relocation, sonoma:         "bcb24ff49fc09c80c355ebd84292c6d326ad87663f2092249c6e0f96d19716f6"
    sha256 cellar: :any_skip_relocation, ventura:        "d2263ecdbc0dbfa17c76364666d0cc6f8b264c22e5a9128c3e8c61f884a7fb40"
    sha256 cellar: :any_skip_relocation, monterey:       "f9501d59ea77deaffd613d4e12c726d4018625b367cb2677e0353b62b54e64a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b44f481de5bdd8edd16057b325e684c1e9fdb7bc095f186c4bdb170a4e35df5a"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    man1.install "doc/fd.1"
    generate_completions_from_executable(bin/"fd", "--gen-completions", shells: [:bash, :fish])
    zsh_completion.install "contrib/completion/_fd"
    # Bash completions are not compatible with Bash 3 so don't use v1 directory.
    # bash: complete: nosort: invalid option name
    # Issue ref: https://github.com/clap-rs/clap/issues/5190
    (share/"bash-completion/completions").install bash_completion.children
  end

  test do
    touch "foo_file"
    touch "test_file"
    assert_equal "test_file", shell_output("#{bin}/fd test").chomp
  end
end
