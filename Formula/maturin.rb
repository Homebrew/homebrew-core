class Maturin < Formula
  desc "Build and publish Rust crates as Python packages"
  homepage "https://github.com/PyO3/maturin"
  url "https://github.com/PyO3/maturin/archive/refs/tags/v0.11.3.tar.gz"
  sha256 "e65864a36be44456da0f9174de12fe3ea02bb87a968b5333ace3b122869dd6b2"
  license "MIT"
  head "https://github.com/PyO3/maturin.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "1d5d727dd07fb57ca4545a8c2d2fb3ab3c88a45c816de17777b5d5f33175fe30"
    sha256 cellar: :any_skip_relocation, big_sur:       "2fcd4a193a7356d43647969bd54bc6504305ebbde84b493a2644e3cc5fdc1bc6"
    sha256 cellar: :any_skip_relocation, catalina:      "8558b7555fd7200a9843645d957633bd9b513a19c4f122f05ad4024fa657d426"
    sha256 cellar: :any_skip_relocation, mojave:        "e13ce6649031fb1388293570bae38374056ea82c3a6e1f9e917939ad14f60540"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eccaf6962552f9b766a0d75681896bdfa04c571e7cce9396b6e10ffe7911370f"
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
