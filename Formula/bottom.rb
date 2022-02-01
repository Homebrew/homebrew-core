class Bottom < Formula
  desc "Yet another cross-platform graphical process/system monitor"
  homepage "https://clementtsang.github.io/bottom/"
  url "https://github.com/ClementTsang/bottom/archive/0.6.7.tar.gz"
  sha256 "22c8da50a90e3d0b53fb12ff9311f085b65f4f750a4ed3303c2ec46297d3d557"
  license "MIT"
  head "https://github.com/ClementTsang/bottom.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b835e61aced353b7ed4d026b2b9fb7795b95be6e602b08eecf80dc0026712d45"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "de21ad9f96ee4b82576b1c0348a8d23eaa8cff94480a435423a8ba4d6c62f189"
    sha256 cellar: :any_skip_relocation, monterey:       "6773f765d85e25a82aa671a396798fa58d77d991ab8dadbe4b04a26974539c43"
    sha256 cellar: :any_skip_relocation, big_sur:        "41e032d62c7119e33bd4f0844550b9340429329f56591878ec6bf51cf40948e7"
    sha256 cellar: :any_skip_relocation, catalina:       "05bd8396c06f8e209509899eaebaad8c0803c95fd29844a3e7e72d181536e7a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d286d974fb73242f108ebcda4a49da71a8c17b747b87b193d6b0ee28ca4eed17"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    # Completion scripts are generated in the crate's build
    # directory, which includes a fingerprint hash. Try to locate it first
    out_dir = Dir["target/release/build/bottom-*/out"].first
    bash_completion.install "#{out_dir}/btm.bash"
    fish_completion.install "#{out_dir}/btm.fish"
    zsh_completion.install "#{out_dir}/_btm"
  end

  test do
    assert_equal "bottom #{version}", shell_output(bin/"btm --version").chomp
    assert_match "error: Found argument '--invalid'", shell_output(bin/"btm --invalid 2>&1", 1)

    fork do
      exec bin/"btm", "--config", "nonexistent-file"
    end
    sleep 1
    assert_predicate testpath/"nonexistent-file", :exist?
  end
end
