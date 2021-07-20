class Maturin < Formula
  desc "Build and publish Rust crates as Python packages"
  homepage "https://github.com/PyO3/maturin"
  url "https://github.com/PyO3/maturin/archive/refs/tags/v0.11.2.tar.gz"
  sha256 "4c37b25c327fedf46c0b0833d0e8a5c69e9edcdfeb5b6c946b94198001044f1d"
  license "MIT"
  head "https://github.com/PyO3/maturin.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "ed392a37bb38d6d592df6ebfd6537a09f1767e7428818822d5ebc92070672451"
    sha256 cellar: :any_skip_relocation, big_sur:       "52beb70866e7f690075b8f4e064eafe5b3d4fed50d739c65a74b6cbdd924d17c"
    sha256 cellar: :any_skip_relocation, catalina:      "d2cd0ef075e0c03f04d09cfd137e0eb453064bda222c60209345e61ea5886415"
    sha256 cellar: :any_skip_relocation, mojave:        "f39c7d8a923f4ec21ee970ca296af04bf803cd5f4c98ea3b4f7c171265e34aa2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aa17682d3bb33f974247ce897adb7d1dddf7b9717b62dbebe56a8590dce100a5"
  end

  depends_on "python@3.9" => :test
  depends_on "rust"

  def install
    system "cargo", "install", *std_cargo_args

    bash_output = Utils.safe_popen_read(bin/"maturin", "completions", "bash")
    (bash_completion/"maturin").write bash_output
    zsh_output = Utils.safe_popen_read(bin/"maturin", "completions", "zsh")
    (zsh_completion/"_maturin").write zsh_output
    fish_output = Utils.safe_popen_read(bin/"maturin", "completions", "fish")
    (fish_completion/"maturin.fish").write fish_output
  end

  test do
    system "cargo", "new", "hello_world", "--bin"
    system bin/"maturin", "build", "-m", "hello_world/Cargo.toml", "-b", "bin", "-o", "dist", "--compatibility", "off"
    system "python3", "-m", "pip", "install", "hello_world", "--no-index", "--find-links", testpath/"dist"
    system "python3", "-m", "pip", "uninstall", "-y", "hello_world"
  end
end
